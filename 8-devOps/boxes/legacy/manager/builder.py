import os
from os.path import join
import json

directories_to_remove = ['.git', 'examples', '.idea', '.venv']


def remove_dirs(dirs_to_remove, current_dirs):
    for d in dirs_to_remove:
        if d in current_dirs:
            current_dirs.remove(d)


def get_image_name_with_tag(name, tag):
    r = name.index('/')
    return f"{name[r + 1:]}:{tag}"


results = []
paths = dict()
for root, dirs, files in os.walk('..'):
    ymls = {name for name in files if name.endswith('.yml')}
    for name in files:
        if name.endswith('.json'):
            obj = json.loads(open(join(root, name)).read())
            if 'provisioners' in obj.keys() and obj['provisioners'][0]['playbook_file'] in ymls:
                docker_image_produced = None
                if 'post-processors' in obj.keys() and 'type' in obj['post-processors'][0][0]:
                    if obj['post-processors'][0][0]['type'] == 'docker-tag':
                        docker_image_produced = get_image_name_with_tag(
                            obj['post-processors'][0][0]['repository'],
                            obj['post-processors'][0][0]['tag'])
                        paths[docker_image_produced] = (root, name)
                docker_image_needed = None
                if 'builders' in obj.keys() and 'type' in obj['builders'][0]:
                    if obj['builders'][0]['type'] == 'docker':
                        docker_image_needed = obj['builders'][0]['image']

                if docker_image_needed and docker_image_produced:
                    results.append((docker_image_needed,
                                    docker_image_produced))

    remove_dirs(directories_to_remove, dirs)

from toposort import toposort, toposort_flatten

deps = {p: {n} for (n, p) in results}

print(deps)
print("---------------------------------")
print(list(toposort(deps)))
