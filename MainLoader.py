from tkinter import *
from tkinter import  filedialog
from PIL import ImageTk,Image
import re
import os
import subprocess

class Root(Tk):
    def __init__(self):
        super(Root, self).__init__()
        self.title("HTML5IFY")
        #self.minsize(830,150)
        self.configure(background='#F0F4F6')
        self.geometry("830x350")
        self.resizable(0, 0)
        self.initUI()

    def initUI(self):
        self.browseButton = Button(self, relief=RAISED, text="Browse File", font=('helvetica', 12, 'bold'), padx=5,
                                   pady=7, command=self.fileDialog)
        self.browseButton.place(relx=.1, rely=.2, anchor="c")

        large_font = ('Verdana', 15)
        self.fileNameTextbox = Entry(self, relief=SUNKEN, width=48, font=large_font)
        self.fileNameTextbox.place(relx=.55, rely=.2, anchor="c")

        self.convertButton = self.QCButton()
        self.bgImage()

    def bgImage(self):
        self.img = ImageTk.PhotoImage(Image.open("Back-2.png"))
        self.canvas = Canvas(self, width = 440, height = 120, highlightthickness = 0, bg="#F0F4F6")
        self.canvas.create_image(20, 20, anchor=NW, image=self.img)
        self.canvas.image = self.img
        self.canvas.grid(row = 5, column = 1, padx = 180, pady = 180)

    def browseFileButton(self):
        self.browseButton = Button(self, relief=RAISED, text="Browse File", font=('helvetica', 12, 'bold'), padx=5, pady=7, command=self.fileDialog)
        self.browseButton.place(relx=.1, rely=.2, anchor="c")


    def QCButton(self):
        self.convertButton = Button(self, relief=RAISED, text="Fix Style Violations", font=('helvetica', 12, 'bold'), padx=7, pady=7, command=self.fixHTML5Violations)
        self.convertButton.place(relx=.5, rely=.4, anchor="c")

    def fixHTML5Violations(self):
        self.extractStyleViolationsToCSS(self.fileNameTextbox.get())


    def fileDialog(self):
        self.filename = filedialog.askopenfilename(initialdir = "/", title = "select a file", filetype = (("JSP", "*.jsp"), ("All Files", "*.*")))
        self.fileNameTextbox.insert(0,self.filename)


    def extractStyleViolationsToCSS(self, fileName):
        psxmlgen = subprocess.Popen([r'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe',
                                     '-ExecutionPolicy',
                                     'Unrestricted',
                                     './cssAutoFix.ps1'])
        psxmlgen.wait()
        filePath = os.listdir("C:\\Users\\VI041281\\Desktop\\Hackathon_2019_Feb-8\\HTML5IFY\\SC")[0]
        try:
            output_file = open("C:\\Users\\VI041281\\Desktop\\Hackathon_2019_Feb-8\\HTML5IFY\\output.css", "w")
            Modified_file = open("C:\\Users\\VI041281\\Desktop\\Hackathon_2019_Feb-8\\HTML5IFY\\ModifiedOutput.jsp", "w")
            rules_file = "C:\\Users\\VI041281\\Desktop\\Hackathon_2019_Feb-8\\HTML5IFY\\rules.txt"
        except IOError:
            print("Could not open file")
        with open(fileName) as file:
            line_no = 0
            for line in file:
                line_no += 1
                countOpen = line.count('<')
                countClose = line.count('>')
                if countClose == countOpen:
                    with open(rules_file) as rules:
                        loop = 0
                        ruleFound = "false"
                        replace_no = 0
                        replaceAtt = ""
                        inlineAttributes = ""
                        for index, rule in enumerate(rules):
                            loop += 1
                            rule = rule.split("@@")
                            ruleToBeApplied = rule[0].strip()
                            result = re.search(ruleToBeApplied, line)
                            if not result:
                                continue
                            elif result:
                                ruleFound = "true"
                                ruleNo = rule[1].strip()
                                if ruleNo == "Rule1":
                                    if result is not None:
                                        className = filePath.split('.')[0] + str(line_no)
                                        classSearch = re.search(r'(class)="([^"]*)"', line)
                                    if not (classSearch):
                                        inlineClassName = line.replace(result.group(0),
                                                                       " class = " + '"' + className + '"')
                                        Modified_file.write(line.replace(line, inlineClassName))
                                    elif classSearch:
                                        names = classSearch.group(1) + "=" + '"' + classSearch.group(
                                            2) + " " + className + '"'
                                        res = re.sub(r'(style)="([^"]*)"', "", line)
                                        inlineClassName = res.replace(classSearch.group(0), names)
                                        Modified_file.write(res.replace(res, inlineClassName))
                                    styleRes = result.group(2).replace('=', ':')
                                    print(styleRes, index + 1)
                                    output_file.write(className + " { ")
                                    output_file.write(styleRes + " } ")
                                    output_file.write("\n")
                                elif ruleNo == "Rule2":
                                    classExist = re.search(r'(class)="([^"]*)"', line)
                                    if result is not None:
                                        nonStyle = (result[0]).strip()
                                        classNameAttr = filePath.split('.')[0] + str(line_no)
                                    if (inlineAttributes == "" and nonStyle):
                                        inlineAttributes = nonStyle
                                    elif inlineAttributes:
                                        inlineAttributes = inlineAttributes + "; " + nonStyle
                                    if (replaceAtt == ""):
                                        if not classExist:
                                            replaceAtt = line.replace(nonStyle, " class = " + '"' + classNameAttr + '"')
                                        elif classExist:
                                            replaceAtt = line.replace(nonStyle, "")
                                    elif replaceAtt:
                                        replaceAtt = replaceAtt.replace(nonStyle, "")
                                        replace_no = line_no

                        if (replace_no == line_no and replaceAtt != ""):
                            if classExist:
                                classConcat = classExist[2] + " " + classNameAttr
                                classConcat = ("class =" + '"' + classConcat + '"')
                                replaceAttConcat = (replaceAtt.replace(classExist[0], classConcat))
                                Modified_file.write(replaceAttConcat)
                            else:
                                Modified_file.write(replaceAtt)
                        if inlineAttributes != "" and inlineAttributes is not None:
                            inlineAttributes = inlineAttributes.replace('=', ':')
                            inlineAttributes = inlineAttributes.replace('"', '')
                            output_file.write(classNameAttr + " { ")
                            output_file.write(inlineAttributes + "; } ")
                            output_file.write("\n")
                        if ruleFound == "false":
                            Modified_file.write(line)
        Modified_file.close()
        output_file.close()


if __name__ == '__main__':
        root = Root()
        root.mainloop()