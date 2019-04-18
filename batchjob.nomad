job "tryterminate" {
  datacenters = ["dc1"]
  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "windows"
  }


  parameterized {
    payload       = "required"
    meta_required = ["TTL"] #ttl is the amount of time this batch job will run for before it gets executed
  }

  group "clients1" {
    count = 1
    task "callexe" {

 template {
        data = <<EOH
          start dotnet-batch-service.exe
          ping 127.0.0.1 -n ${NOMAD_META_TTL}
          taskkill /im dotnet-batch-service.exe /f
        EOH
        destination = "C:\\HashiCorp\\Nomad_Jobs\\runbatch.ps1"
      }

      driver = "raw_exec"
       resources {
        cpu    = 1000
        memory = 256
        }

        kill_signal = "SIGKILL"
        kill_timeout = "20s"
        leader = "true"
        
        artifact {
           source      = "git::https://github.com/GuyBarros/dotnet-batch-service"
           destination = "C:\\HashiCorp\\Nomad_Jobs\\"
         }

        config {
          command = "powershell.exe"
          args = ["C:\\HashiCorp\\Nomad_Jobs\\runbatch.ps1"]
         }

    }

  }

}

 