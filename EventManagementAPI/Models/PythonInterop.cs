using System;
using System.Diagnostics;
public class PythonInterop
{
    public static async Task<Double> EvaluateSimilarity(String event1Str, String event2Str) {
        try {
            // Prepare the Python process
            ProcessStartInfo psi = new ProcessStartInfo
            {
                FileName = "python3",
                Arguments = "PythonScripts\\W2V.py",
                RedirectStandardInput = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            // Start the Python process
            Process pythonProcess = new Process { StartInfo = psi };
            pythonProcess.Start();

            // Send the event data to the Python script
            pythonProcess.StandardInput.WriteLine(event1Str);
            pythonProcess.StandardInput.WriteLine(event2Str);
            pythonProcess.WaitForExit();

            if (pythonProcess.ExitCode != 0) {
                Console.WriteLine(pythonProcess.StandardError.ReadToEnd());
            }

            // Read the similarity rating from the Python script
            Double result = Double.Parse(pythonProcess.StandardOutput.ReadToEnd());

            // Close the Python process
            pythonProcess.Close();

            return result;
        } catch {
            return 0.0;
        }
    }
}