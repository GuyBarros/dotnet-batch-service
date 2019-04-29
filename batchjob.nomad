job "batchjob" {
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
          start "\\Hashicorp\\Nomad_Jobs\\dotnet-batch-service.exe"
          ping 127.0.0.1 -n 30
          taskkill /im dotnet-batch-service.exe /f
        EOH
        destination = "${NOMAD_ALLOC_DIR}\\Hashicorp\\Nomad_Jobs\\runbatch.ps1"
      }

      driver = "raw_exec"
       resources {
        cpu    = 1000
        memory = 256
        }

//${NOMAD_META_TTL}
        //kill_signal = "SIGKILL"
        //kill_timeout = "20s"
        //leader = "true"
        
        artifact {
           source   = "git::https://github.com/GuyBarros/dotnet-batch-service"
            destination = "${NOMAD_ALLOC_DIR}\\Hashicorp\\Nomad_Jobs\\"
           
         }

        config {
      #  command = "\\Hashicorp\\Nomad_Jobs\\dotnet-batch-service.exe" // This works
          command = "powershell.exe"
          args = ["${NOMAD_ALLOC_DIR}\\Hashicorp\\Nomad_Jobs\\runbatch.ps1"]
        #   args = ["\\Hashicorp\\Nomad_Jobs\\dotnet-batch-service.exe"] 
         }

    }

  }

}

 