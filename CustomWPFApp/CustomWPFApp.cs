using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace CustomWPFApp
{
    public class App : System.Windows.Application
    {
        private string _XAML_PATH = "./CustomWpfApp/Views/MainWindow.xaml";

        public App()
        {
            try
            {
                MainWindow = (MainWindow)XamlReader.Parse(File.ReadAllText(_XAML_PATH));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                if (ex.InnerException != null)
                {
                    Console.WriteLine("Inner Exception: " + ex.InnerException.Message);
                    Console.WriteLine("Stack Trace: " + ex.InnerException.StackTrace);
                }
            }
        }

        public void Start()
        {
            Run(MainWindow);
        }
    }
}
