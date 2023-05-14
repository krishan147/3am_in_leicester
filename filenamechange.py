import os, glob

directory = r"C:\google_drive\homeworkv2\godot\3am in Leicester\game\output_rename"

for file in glob.glob(os.path.join(directory, "*.jpg")):
    print (file)
    os.rename(file, file.replace("-0000",""))