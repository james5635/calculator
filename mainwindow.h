#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

enum class ButtonType { Digit, Operation, Clear, Equals, Unknown };
class MainWindow : public QMainWindow {
    Q_OBJECT

  public:
    MainWindow(QWidget* parent = nullptr);
    void handleButton();
    void handleDigit(const QString& digit);
    void handleOperation(const QString& operation);
    void handleEquals();
    ButtonType getButtonType(const QString& buttonText) const;
    double evaluateExpression(const QString& expression);
    int precedence(QChar op) const;
    double applyOperator(double a, double b, QChar op) const;
    ~MainWindow();

  private:
    Ui::MainWindow* ui;
    void onExit();
    void onAbout();
};
#endif // MAINWINDOW_H
