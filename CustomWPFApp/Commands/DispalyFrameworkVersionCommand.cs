using System.Runtime.InteropServices;

public class DisplayFrameworkVersionCommand : RelayCommand
{
  private readonly MainWindowVM _viewModel;

  public DisplayFrameworkVersionCommand(MainWindowVM viewModel)
      : base(param => ExecuteCommand(viewModel), param => CanExecuteCommand())
  {
    _viewModel = viewModel;
  }

  private static void ExecuteCommand(MainWindowVM viewModel)
  {
    string version = RuntimeInformation.FrameworkDescription;
    viewModel.Btn2Content = "Binded + RelayCommand click worked";
    viewModel.OnPropertyChanged("Btn2Content");
    MessageBox.Show(version);
  }

  private static bool CanExecuteCommand() {return true;}
}