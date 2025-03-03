using System.Windows.Input;

public class RelayCommand : ICommand
{
  private Action<object> _execute;

  private Func<object, bool> _canExecute;

  public event EventHandler CanExecuteChanged
  {
    add { CommandManager.RequerySuggested += value; }
    remove { CommandManager.RequerySuggested -= value; }
  }

  public RelayCommand(Action execute, Func<object, bool> canExecute = null)
  {
    _execute = (param) => execute();
    _canExecute = canExecute;
  }

  public RelayCommand(Action<object> execute, Func<object, bool> canExecute = null)
  {
    _execute = execute;
    _canExecute = canExecute;
  }

  public bool CanExecute(object parameter)
  {
    if (_canExecute == null)
      return true;

    return _canExecute(parameter);
  }

  public void Execute(object parameter)
  {
    _execute(parameter);
  }
}
