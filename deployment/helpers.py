import os
import subprocess
import yaml
import zipfile


def get_executables(executables_path="executables.yaml"):
    with open(executables_path, "r") as fi:
        executables = yaml.load(fi)

    return executables["qmake"], executables["jom"], executables["windeployqt"]


def call_process(args):
    p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    output, err = p.communicate()
    print("stdout:\n", output)
    print("stderr:\n", err)

    if p.returncode != 0:
        raise Exception(
            f"Process {args} returned non zero code: {p.returncode}"
        )
    return p.returncode


def call_qmake(
    qmake_path, project_path, args=["-nocache", "-spec", "win32-msvc"]
):
    call_process([qmake_path, project_path] + args)


def call_jom(jom_path):
    call_process([jom_path])


def call_windeployqt(windeployqt_path, exe_path, repository_path):
    call_process(
        [windeployqt_path, exe_path, "--qmldir", repository_path, "-xml"]
    )


def zip_directory(dir_path, zip_name):
    with zipfile.ZipFile(zip_name, "w", zipfile.ZIP_DEFLATED) as ziph:
        for root, dirs, files in os.walk(dir_path):
            for filename in files:
                ziph.write(os.path.join(root, filename))
