// Copyright (C) 2025 james5635
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
// 
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
#include "mainwindow.h"
#include "qmessagebox.h"
#include "qregularexpression.h"
#include "ui_mainwindow.h"
#include <QAction>
#include <QCoreApplication>
#include <QDebug>
#include <QMessageBox>
#include <QRegularExpression>
#include <QStack>
MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    std::vector<QPushButton*> Buttons = {
        ui->pushButton_0,        ui->pushButton_1,        ui->pushButton_2,
        ui->pushButton_3,        ui->pushButton_4,        ui->pushButton_5,
        ui->pushButton_6,        ui->pushButton_7,        ui->pushButton_8,
        ui->pushButton_9,        ui->pushButton_plus,     ui->pushButton_minus,
        ui->pushButton_multiply, ui->pushButton_division, ui->pushButton_clear,
        ui->pushButton_eq,
    };
    for (auto btn : Buttons) {
        connect(btn, &QPushButton::released, this, &MainWindow::handleButton);
    }
    connect(ui->actionExit, &QAction::triggered, this, &MainWindow::onExit);
    connect(ui->actionAbout, &QAction::triggered, this, &MainWindow::onAbout);
}
void MainWindow::onExit() { QCoreApplication::quit(); }
void MainWindow::onAbout() {
    QMessageBox::about(
        this, "About",
        "This program is written by james5635.\nIt is licensed under GPL.");
}
void MainWindow::handleButton() {
    QPushButton* button = qobject_cast<QPushButton*>(sender());
    if (!button)
        return;
    /*
     * ~/.config/kdeglobals
     *
     * [Development]
     * AutoCheckAccelerators=false
     */
    QString buttonText = button->text().replace("&", "");
    ButtonType buttonType = getButtonType(buttonText);

    switch (buttonType) {
    case ButtonType::Digit:
        handleDigit(buttonText);
        break;

    case ButtonType::Operation:
        handleOperation(buttonText);
        break;

    case ButtonType::Clear:
        ui->label->clear();
        break;

    case ButtonType::Equals:
        handleEquals();
        break;

    default:
        qDebug() << "Unhandled button type: " << buttonText;
        break;
    }
}

void MainWindow::handleEquals() {
    QString expression = ui->label->text();

    // Evaluate the expression
    double result = evaluateExpression(expression);

    // Display the result
    ui->label->setText(QString::number(result));
}

double MainWindow::evaluateExpression(const QString& expression) {
    // Simple evaluation logic for expressions like "3 + 5 * 2"
    QStack<double> values;
    QStack<QChar> ops;

    QStringList tokens = expression.split(' ', Qt::SkipEmptyParts);
    qDebug() << tokens;
    QRegularExpression re("\\d+");
    for (const QString& token : tokens) {
        QRegularExpressionMatch match = re.match(token);
        if (match.hasMatch()) {
            qDebug() << "matching digit ..." << token;
            // Push numbers onto the value stack
            values.push(token.toDouble());
        } else if (token == "+" || token == "-" || token == "*" ||
                   token == "/") {
            qDebug() << "matching token ..." << token;
            // Push operators onto the operator stack
            while (!ops.isEmpty() &&
                   precedence(ops.top()) >= precedence(token[0])) {
                double val2 = values.pop();
                double val1 = values.pop();
                QChar op = ops.pop();
                values.push(applyOperator(val1, val2, op));
            }
            ops.push(token[0]);
        }
    }

    // Process remaining operators
    while (!ops.isEmpty()) {
        double val2 = values.pop();
        double val1 = values.pop();
        QChar op = ops.pop();
        values.push(applyOperator(val1, val2, op));
    }

    // The final value in the stack is the result
    return values.top();
}

int MainWindow::precedence(QChar op) const {
    if (op == "+" || op == "-")
        return 1;
    if (op == "*" || op == "/")
        return 2;
    return 0;
}

double MainWindow::applyOperator(double a, double b, QChar op) const {
    switch (op.toLatin1()) {
    case '+':
        return a + b;
    case '-':
        return a - b;
    case '*':
        return a * b;
    case '/':
        return b != 0 ? a / b : 0; // Avoid division by zero
    default:
        return 0;
    }
}
ButtonType MainWindow::getButtonType(const QString& buttonText) const {
    if (buttonText >= "0" && buttonText <= "9") {
        return ButtonType::Digit;
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "*" ||
               buttonText == "/") {
        return ButtonType::Operation;
    } else if (buttonText == "clear") {
        return ButtonType::Clear;
    } else if (buttonText == "=") {
        return ButtonType::Equals;
    }
    return ButtonType::Unknown;
}
void MainWindow::handleDigit(const QString& digit) {
    ui->label->setText(ui->label->text() + digit);
}

void MainWindow::handleOperation(const QString& operation) {
    ui->label->setText(ui->label->text() + " " + operation + " ");
}
MainWindow::~MainWindow() { delete ui; }
