
public class MainWindowVM : ViewModelBase
{
  public RelayCommand DisplayFrameworkVersionCommand { get; set; }

  private string _btn2Content;
  public string Btn2Content
  {
    get { return _btn2Content; }
    set { _btn2Content = value; }
  }

  public MainWindowVM()
  {
    _btn2Content = "Test Bindings & RelayCommand";
    DisplayFrameworkVersionCommand = new DisplayFrameworkVersionCommand(this);
  }
}