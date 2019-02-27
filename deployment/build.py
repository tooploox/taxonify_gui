# local python path is
# C:/Users/mituser/AppData/Local/Programs/Python/Python36-32/python.exe

import os
import shutil

import fire

from helpers import (
    get_executables,
    call_qmake,
    call_jom,
    call_windeployqt,
    zip_directory,
)


def build_e2e(
    repository_path, output_zip_path, executables_path="executables.yaml"
):
    repository_path = os.path.abspath(repository_path)

    cwd = os.getcwd()

    qmake, jom, windeployqt = get_executables(executables_path)

    aquascope_gui_pro_path = os.path.join(repository_path, "aquascope_gui.pro")
    print(f"\nBuidling: {aquascope_gui_pro_path}\n")
    call_qmake(qmake, aquascope_gui_pro_path)
    call_jom(jom)

    os.chdir(os.path.join(repository_path, "lib"))
    print(f"\nBuidling: {os.getcwd()}\n")
    call_qmake(qmake, "lib.pro")
    call_jom(jom)

    os.chdir(repository_path)
    print(f"\nBuidling: {os.getcwd()}\n")
    call_qmake(qmake, aquascope_gui_pro_path)
    call_jom(jom)

    release_path = os.path.join(
        repository_path,
        "app",
        "release",
    )
    executable_path = os.path.join(release_path, "AquascopeGUI.exe")
    print("\nWindeployQT\n")
    call_windeployqt(windeployqt, executable_path, repository_path)

    lib_path = os.path.join(repository_path, "lib", "release", "lib.dll")
    shutil.copy(lib_path, release_path)

    os.chdir(cwd)
    zip_directory(os.path.relpath(release_path, cwd), output_zip_path)


if __name__ == "__main__":
    fire.Fire(build_e2e)
