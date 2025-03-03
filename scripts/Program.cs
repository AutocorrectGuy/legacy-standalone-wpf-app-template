using System;
using System.IO;
using System.Windows;
using System.Windows.Markup;
using System.Windows.Controls;

public class Program
{
  public static void Main()
  {
    Application app = XamlReader.Parse(File.ReadAllText("./xaml/Application.xml")) as Application;
    app.MainWindow = XamlReader.Parse(File.ReadAllText("./xaml/MainWindow.xml")) as Window;
    app.MainWindow.DataContext = new MainWindowVM(app.MainWindow);
    app.Run(app.MainWindow);
  }
}