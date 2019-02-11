import re
import os
import time
import linecache
import subprocess
psxmlgen = subprocess.Popen([r'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe',
                             '-ExecutionPolicy',
                             'Unrestricted',
                             './cssAutoFix.ps1'])
psxmlgen.wait()
filePath = os.listdir(".\\SC")[0]
try:
 output_file = open("C:\\Users\\MS040940\Desktop\\HTML5 conversion\\output.css", "w")
 input_file = open("C:\\Users\\MS040940\\Desktop\HTML5 conversion\\ModifiedOutput.jsp", "w")
 rules_file = "C:\\Users\MS040940\\Desktop\HTML5 conversion\\rules.txt"
except IOError:
 print ("Could not open file") 
with open("Input.jsp") as file:
 line_no = 0
  #changes start
 for line in file:
  line_no += 1 
  countOpen = line.count('<')
  countClose = line.count('>')
  if countClose == countOpen:
   with open(rules_file) as rules:
    #rule 2 variables
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
        if not(classSearch):
         inlineClassName = line.replace(result.group(0), " class = " + '"' + className + '"')
         input_file.write(line.replace(line, inlineClassName))
        elif classSearch:
         names=classSearch.group(1) + "=" + '"'+ classSearch.group(2)+ " " + className + '"'
         res = re.sub(r'(style)="([^"]*)"',"",line)
         inlineClassName = res.replace(classSearch.group(0), names)
         input_file.write(res.replace(res, inlineClassName))
        styleRes = result.group(2).replace('=',':')
        print(styleRes, index + 1)
        output_file.write(className + " { ")
        output_file.write(styleRes + " } ")
        output_file.write("\n")
       elif ruleNo == "Rule2":
        classExist = re.search(r'(class)="([^"]*)"', line)
        if result is not None:
         nonStyle=(result[0]).strip()   
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
        input_file.write(replaceAttConcat)
      else:
        input_file.write(replaceAtt)
    if inlineAttributes != "" and inlineAttributes is not None:
     inlineAttributes = inlineAttributes.replace('=',':')
     inlineAttributes = inlineAttributes.replace('"', '')   
     output_file.write(classNameAttr + " { ")
     output_file.write(inlineAttributes + "; } ")
     output_file.write("\n")
    if ruleFound == "false":
      input_file.write(line)
input_file.close()
output_file.close()
