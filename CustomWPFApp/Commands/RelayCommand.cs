using System.Windows.Input;

public class RelayCommand : ICommand
{
  private Action<object> _execute;
  private Func<object, bool> _canExecute;

  public RelayCommand(Action<object> execute, Func<object, bool> canExecute)
  {
    _execute = execute;
    _canExecute = canExecute;
  }

  public bool CanExecute(object param)
  {
    if (param == null) return true;
    return _canExecute(param);
  }

  public void Execute(object param)
  {
    _execute(param);
  }

  public event EventHandler CanExecuteChanged
  {
    add { CommandManager.RequerySuggested += value; }
    remove { CommandManager.RequerySuggested -= value; }
  }

}