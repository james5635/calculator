// Copyright (C) 2025 james5635
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
// 
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
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
