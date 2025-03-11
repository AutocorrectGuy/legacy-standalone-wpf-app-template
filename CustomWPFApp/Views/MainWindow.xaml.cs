namespace CustomWPFApp
{
  public class MainWindow : Window
  {
    public MainWindow()
    {
      DataContext = new MainWindowVM();
    }

    public void HandleClick(object sender, RoutedEventArgs e)
    {
      Button btn = (Button)sender;
      btn.Content = "Tight coupled click worked!";
    }
  }

}