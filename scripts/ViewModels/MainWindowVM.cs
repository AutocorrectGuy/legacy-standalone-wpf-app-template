using System.Text.RegularExpressions;
using System.Runtime.InteropServices;
using System.Windows;

public class MainWindowVM : ViewModelBase
{
  private Window _window;

  private string _frameworkVersion;

  public string FrameworkVersion
  {
    get { return _frameworkVersion; }
    set { _frameworkVersion = value; OnPropertyChanged(); }
  }

  private RelayCommand _testCommand;

  public RelayCommand TestCommand
  {
    get
    {
      if (_testCommand == null)
        _testCommand = new RelayCommand(_testCommandCallback);
      return _testCommand;
    }
  }

  public MainWindowVM(Window window)
  {
    _frameworkVersion = RuntimeInformation.FrameworkDescription;
    _testCommand = new RelayCommand(_testCommandCallback);
    _window = window;
  }

  private void _testCommandCallback()
  {
    MessageBox.Show("Relay command works successfully");
  }
}