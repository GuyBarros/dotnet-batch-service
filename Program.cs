using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace dotnet_batch_service
{
    class Program
    {
        static void Main(string[] args)

        {
            StreamWriter sw = new StreamWriter(@".\PrimeNumbers.txt");
            sw.AutoFlush = true;
            Console.SetOut(sw);

            Parallel.For(0, int.MaxValue, i =>

            {

                Thread.CurrentThread.Priority = ThreadPriority.Lowest;

                if (IsPrimeNumber(i)){
                   // Console.WriteLine(i + " is a prime number.");
                    Console.Out.WriteLine(i);
                }

            });

        }



        public static bool IsPrimeNumber(long testNumber)

        {
            if (testNumber < 2) return false;

            if (testNumber % 2 == 0) return false;

            long upperBorder = (long)System.Math.Round(System.Math.Sqrt(testNumber), 0);

            for (long i = 3; i <= upperBorder; i = i + 2)

                if (testNumber % i == 0) return false;

            return true;

        }
    }
}
