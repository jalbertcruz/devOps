import json
import os
import subprocess
import sys
import typer

def transform_resolution(resolution):
    if resolution is None:
        return 'null'
    if 'x' in resolution:
        parts = resolution.split('x')
        if len(parts) == 2:
            return f"resolution({parts[1]}, {parts[0]})"
    return 'null'

def get_field(f, key, wrap_str=True, to_int=False):
    val = f.get(key, 'null')
    if val is None:
        val = 'null'
    if to_int and val != 'null':
        val = int(val)
    if wrap_str and val != 'null':
        val = f"'{val}'"
    return val

def create_picat_db_aux(fid, jsons_dir="jsons", output_dir="picat_db"):
    obj = json.loads(open(f"{jsons_dir}/{fid}.json").read())
    formats = ["module db1."]
    for f in obj["formats"]:
        format_id = get_field(f, "format_id")
        filesize = get_field(f, "filesize", wrap_str=False, to_int=True)
        ext = get_field(f, "ext")
        vcodec = get_field(f, "vcodec")
        acodec = get_field(f, "acodec")
        video_ext = get_field(f, "video_ext")
        audio_ext = get_field(f, "audio_ext")
        resolution = transform_resolution(f.get("resolution", 'null'))
        language = get_field(f, "language")
        f_str = f"format({format_id}, {filesize}, {ext}, {vcodec}, {acodec}, {video_ext}, {audio_ext}, {resolution}, {language})."
        # print(f_str)
        formats.append(f_str)

    open(f"{output_dir}/{fid}.pi", "w").write("\n".join(formats))


app = typer.Typer()

def gen_video_cases():
    my_env = os.environ.copy()
    try:
        result = subprocess.run(
            ["picat", "picat/video", "640"], stdout=subprocess.PIPE, text=True, env=my_env, check=True
        )
        print(f"'{result.stdout.strip()}'")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while running the Picat script: {e}", file=sys.stderr)
        sys.exit(1)

import shutil

@app.command()
def create_picat_db(jsons_dir="jsons", output_dir="picatdb"):
    """Create Picat database from JSON files."""
    json_files = [f for f in os.listdir(jsons_dir) if f.endswith('.json') and os.path.isfile(os.path.join(jsons_dir, f))]
    for json_file in json_files:
        fid = json_file[:-5]
        create_picat_db_aux(fid=fid, jsons_dir=jsons_dir, output_dir=output_dir)

@app.command()
def run_picat(picat_app_dir="picat", input_dir="picatdb", output_dir="output", lang = "es-US"):
    files = [f for f in os.listdir(input_dir) if f.endswith('.pi') and os.path.isfile(os.path.join(input_dir, f))]
    results = []
    for file in files:
        # shutil.move(f"{input_dir}/{file}", f"{picat_app_dir}/db1.pi")
        shutil.copy(f"{input_dir}/{file}", f"{picat_app_dir}/db1.pi")
        file_path = f"{picat_app_dir}/db1.qi"
        if os.path.exists(file_path):
            os.remove(file_path)
        my_env = os.environ.copy()
        video_id = None
        try:
            result = subprocess.run(
                ["picat", "picat/video", "640"], stdout=subprocess.PIPE, text=True, env=my_env, check=True
            )
            video_id=result.stdout.strip()
        except subprocess.CalledProcessError as e:
            print(f"An error occurred while running the Picat script: {e}", file=sys.stderr)
        audio_id = None
        try:
            result = subprocess.run(
                ["picat", "picat/audio"], stdout=subprocess.PIPE, text=True, env=my_env, check=True
            )
            audio_id=result.stdout.strip()
        except subprocess.CalledProcessError as e:
            print(f"An error occurred while running the Picat script: {e}", file=sys.stderr)
            print(file[:-3])
        res = {"ytv_id": file[:-3]}
        if video_id is not None:
            res["format_id_video"] = video_id
        if audio_id is not None:
            res["format_id_audio"] = audio_id
        results.append(res)
    open(f"{output_dir}/result.json", "w").write(json.dumps(results, indent=2))


if __name__ == "__main__":
    app()
