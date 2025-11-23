import os
import shutil
from pathlib import Path
import tarfile

def make_tar_or_gz_from_dir(src_dir, compact=False):
    """Create a .tar or .tar.bz2 archive from src_dir and return the tar file path.
    If compact is True, create a .tar.bz2 archive, else create a .tar archive.
    """
    src_dir = Path(src_dir).resolve()
    if compact:
        tar_path = src_dir.parent / (src_dir.name + ".tar.bz2")
        mode = "w:bz2"
    else:
        tar_path = src_dir.parent / (src_dir.name + ".tar")
        mode = "w"
    with tarfile.open(tar_path, mode) as tar:
        tar.add(src_dir, arcname=src_dir.name)
    print(f"Created tar file: {tar_path}")
    return tar_path


def copy_file_to_destination(src_file, base_path, base_path_destination):
    """Copy a file to the destination directory, preserving relative path."""
    src_file = Path(src_file).resolve()
    rel_path = src_file.relative_to(base_path)
    dest_file = Path(base_path_destination) / rel_path
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy(src_file, dest_file)


def move_tar_to_destination(tar_path, base_path, base_path_destination):
    """Move a tar file to the destination directory, preserving relative path."""
    tar_path = Path(tar_path).resolve()
    rel_path = tar_path.relative_to(base_path)
    dest_file = Path(base_path_destination) / rel_path
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(tar_path, dest_file)


def move_data(base_path, base_path_destination):
    base_path = Path(base_path).resolve()
    base_path_destination = Path(base_path_destination).resolve()
    for root, dirs, files in os.walk(base_path, topdown=True):
        root_path = Path(root)
        # Handle directories with .git
        for d in list(dirs):
            abs_dir_path = root_path / d / ".git"
            if abs_dir_path.is_dir():
                # Remove from walk, tar and move
                dirs.remove(d)
                tar_path = make_tar_or_gz_from_dir(root_path / d, compact=True)
                move_tar_to_destination(tar_path, base_path, base_path_destination)
                # todo: make a -> git stash && git pull --rebase in "root_path / d"
                # if they are not in a personal repo
                # todo: other version of this algorithm is to update general repos such as the ones from nvim plugins
        # Copy files
        for file in files:
            abs_file_path = root_path / file
            copy_file_to_destination(abs_file_path, base_path, base_path_destination)

def move_data2(base_path, base_path_destination):
    base_path = Path(base_path).resolve()
    base_path_destination = Path(base_path_destination).resolve()
    for root, dirs, files in os.walk(base_path, topdown=True):
        root_path = Path(root)
        # Handle directories with .git
        for d in list(dirs):
            abs_dir_path = root_path / d / ".git"
            if abs_dir_path.is_dir():
                pass
        print(type(d))

base_path_origin = "/home/z/Downloads/temp"
base_path_destination = "/home/z/temp"
move_data2(base_path_origin, base_path_destination)
