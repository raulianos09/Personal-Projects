import os
import subprocess
from tkinter import *
from tkinter import font as tkFont

HOUR_OPTIONS = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']
MINUTE_OPTIONS = ['05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55']


class MainWindow:
    def __init__(self):
        self.__initializeWindow()
        self.__createMainFrame()
        self.__createOptionsDropdown()
        self.__createTimer()
        self.startBtn = self.__createStartBtn(self.root)
        self.defaultsBtn = self.__createDefaultsBtn(self.root)
        self.__loadDefaults()

    def __createMainFrame(self):
        self._mainFrame = Frame(self.root)
        self._mainFrame.pack()

    def __initializeWindow(self):
        self.root = Tk()
        self.root.title("Shutdown clock")
        self.root.geometry('300x400')
        self.root.iconbitmap("Basic_Clock.ico")
        self.root.config(bg='#000000')

    def __createOptionsDropdown(self):
        self.appOptionsVar = StringVar(self._mainFrame)
        self.appOptionsVar.set("OPTIONS")
        self.dropdown = OptionMenu(self._mainFrame, self.appOptionsVar, "Shutdown", "Sleep")
        self._mainFrame.nametowidget(self.dropdown.menuname).config(font=tkFont.Font(family='Helvetica', size=20))
        self.dropdown.config(width=150)
        self.dropdown.config(font=tkFont.Font(family='Helvetica', size=25))
        self.dropdown.pack()

    def __createTimer(self):
        self.__timerFrame = Frame(self.root)
        self.hourDropdownVar = StringVar(self.__timerFrame)
        self.hourDropdownVar.set("HH")
        self.hourDropdown = OptionMenu(self.__timerFrame, self.hourDropdownVar, *HOUR_OPTIONS)
        self.hourDropdown.config(font=tkFont.Font(family='Helvetica', size=25))
        self.hourDropdown.grid(row=0, column=0)

        self.minuteDropdownVar = StringVar(self.__timerFrame)
        self.minuteDropdownVar.set("MM")
        self.minuteDropdown = OptionMenu(self.__timerFrame, self.minuteDropdownVar, *MINUTE_OPTIONS)
        self.minuteDropdown.config(font=tkFont.Font(family='Helvetica', size=25))
        self.minuteDropdown.grid(row=0, column=1)

        self.__timerFrame.nametowidget(self.hourDropdown.menuname).config(font=tkFont.Font(family='Helvetica', size=20))
        self.__timerFrame.nametowidget(self.minuteDropdown.menuname).config(
            font=tkFont.Font(family='Helvetica', size=20))

        self.__timerFrame.pack(padx=20, pady=50)

    def run(self):
        self.root.mainloop()

    def __createStartBtn(self, window):
        button = Button(window, text="START", fg="black", command=self.__startCounter)
        button.pack(side=BOTTOM)
        button.config(width=150)
        button.config(font=tkFont.Font(family='Helvetica', size=25))
        return button

    def __createDefaultsBtn(self, window):
        button = Button(window, text="SET DEFAULT", fg="black", command=self.__saveDefaults)
        button.pack(side=BOTTOM)
        button.config(width=150)
        button.config(font=tkFont.Font(family='Helvetica', size=25))
        return button

    def __loadDefaults(self):
        file = open('defaults.txt', 'r')
        lines = file.readlines()
        self.appOptionsVar.set(lines[0].strip())
        self.hourDropdownVar.set(lines[1].strip())
        self.minuteDropdownVar.set(lines[2].strip())
        file.close()

    def __saveDefaults(self):
        open('defaults.txt', 'w').close()
        file = open('defaults.txt', 'w')
        file.write(self.appOptionsVar.get())
        file.write("\n")
        file.write(self.hourDropdownVar.get())
        file.write("\n")
        file.write(self.minuteDropdownVar.get())
        file.write("\n")
        file.close()

    def __startCounter(self):
        option = self.appOptionsVar.get()
        hour = self.hourDropdownVar.get()
        minute = self.minuteDropdownVar.get()
        self.root.withdraw()
        self.__counter = Counter(option, hour, minute)


class Counter:
    def __init__(self, option, hour, minute):
        self.__initializeWindow()
        self.__createMainFrame()
        self.__option = option
        self.__hour = hour
        self.__minute = minute
        self.__run()

    def __createMainFrame(self):
        self._mainFrame = Frame(self.root)
        self._mainFrame.pack()

    def __initializeWindow(self):
        self.root = Tk()
        self.root.title("Timer")
        self.root.geometry('400x150')
        self.root.iconbitmap("Basic_Clock.ico")
        self.root.config(bg='#000000')

    def __run(self):
        self.timeLabel = Label(self._mainFrame, text=self.__hour + " : " + self.__minute + " : " + "0",
                               font=("helvetica", 60), width=12, bg="black",
                               fg="white", height=2)
        self.timeLabel.pack()
        self.startCountdown()
        self.root.mainloop()

    def countdown(self, count):
        mins, secs = divmod(count, 60)
        hours = 0
        if mins > 60:
            hours, mins = divmod(mins, 60)
        labelText = "{0:2d}".format(hours) + " : " + "{0:2d}".format(mins) + " : " + "{0:2d}".format(secs)
        self.timeLabel.config(text=labelText)
        self._mainFrame.update()
        if count > 0:
            self.root.after(1000, self.countdown, count - 1)
        else:
            return


    def startCountdown(self):
        userinput = int(self.__hour) * 3600 + int(self.__minute) * 60
        self.countdown(userinput)
        if self.__option == "Sleep":
            os.system(f"shutdown /h /t 0")
        elif self.__option == "Shutdown":
            os.system(f"shutdown /s /t 0")


if __name__ == "__main__":
    app = MainWindow()
    app.run()
