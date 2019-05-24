import os
import shutil
import subprocess

from apps_directory_mapping import APPNAME_TO_DIRECTORY


pyfiles = ["requirements.txt", "Procfile"]
rfiles = ["Aptfile", "init.R", "Procfile", ".buildpacks"]

app_name = os.environ["DASH_APP_NAME"]

app_path = os.path.join("apps", APPNAME_TO_DIRECTORY.get(app_name, app_name))

if "DOKKU_SCALE" in os.listdir(app_path):
    shutil.copyfile(os.path.join(app_path, "DOKKU_SCALE"), "DOKKU_SCALE")

if "dashr" in app_name:
    for rfile in rfiles:
        shutil.copyfile(os.path.join(app_path, rfile), rfile)
else:
    for f in pyfiles:
        shutil.copyfile(os.path.join(app_path, f), f)

subprocess.run("python -m pip install -r requirements.txt".split(" "))
