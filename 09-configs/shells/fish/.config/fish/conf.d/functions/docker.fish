function vackup-export_f
    set FILE_NAME $argv[1]
    set VOLUME_NAME $argv[2]
    docker run --rm \
        -v "$VOLUME_NAME":/vackup-volume \
        -v (pwd):/vackup \
        busybox \
        tar -zcvf /vackup/"$FILE_NAME" /vackup-volume

end

function ddvolumes
    for VOLUME_NAME in (docker volume ls | hck -f2 | fzf -m)
        docker volume rm "$VOLUME_NAME"
    end
end

function ddvolumes-by-prefix
    set prefix $argv[1]
    for VOLUME_NAME in (docker volume ls | hck -f2 | tail -n +2 | rg $prefix)
        docker volume rm "$VOLUME_NAME"
    end
end

function vackup-bulk-export
    set prefix $argv[1]
    mkdir -p $prefix
    cd $prefix
    for i in (docker volume ls | hck -f2 | tail -n +2 | rg $prefix)
        set FILE_NAME "$i.tar.gz"
        set VOLUME_NAME "$i"
        vackup-export_f "$FILE_NAME" "$VOLUME_NAME"
    end
    cd ..
end

function vackup-export
    # git@github.com:BretFisher/docker-vackup.git
    set FILE_NAME (gum input --placeholder "gz file name").tar.gz
    set VOLUME_NAME (docker volume ls | fzf | hck -f2 | tr -d "\n")
    if [ "$VOLUME_NAME" ]; and [ "$FILE_NAME" ]
        vackup-export_f "$FILE_NAME" "$VOLUME_NAME"
    end
end

function vackup-import_f
    set FILE_NAME $argv[1]
    set VOLUME_NAME $argv[2]
    set DIRECTORY $argv[3]
    docker volume rm "$VOLUME_NAME"
    docker volume create "$VOLUME_NAME"
    echo "Importing $FILE_NAME into volume $VOLUME_NAME"
    docker run --rm \
        -v "$VOLUME_NAME":/vackup-volume \
        -v "$DIRECTORY":/vackup \
        busybox \
        tar -xvzf /vackup/"$FILE_NAME" -C /

end

function vackup-bulk-import
    set prefix $argv[1]
    cd $prefix
    set DIRECTORY (pwd)
    for i in (ls *.tar.gz | hck -f1)
        set FILE_NAME $i
        set original $i
        set VOLUME_NAME (string sub -l (math (string length $original) - 7) $original)
        vackup-import_f "$FILE_NAME" "$VOLUME_NAME" "$DIRECTORY"
    end
    cd ..
end

function vackup-import
    set gz_files (ls *.tar.gz | hck -f1)
    set FILE_NAME (gum choose $gz_files)
    set VOLUME_NAME (docker volume ls | fzf | hck -f2 | tr -d "\n")
    set DIRECTORY (pwd)
    if [ "$VOLUME_NAME" ]; and [ "$FILE_NAME" ]
        vackup-import_f "$FILE_NAME" "$VOLUME_NAME" "$DIRECTORY"
    end
end

function vackup-save
    set VOLUME_NAME (docker volume ls | fzf | hck -f2 | tr -d "\n")
    set IMAGE_NAME (gum input --placeholder "result image name")
    if [ "$VOLUME_NAME" ]; and [ "$IMAGE_NAME" ]
        docker run \
            -v "$VOLUME_NAME":/mount-volume \
            busybox \
            cp -Rp /mount-volume/. /volume-data/

        set CONTAINER_ID (docker ps -lq)
        docker commit -m "saving volume $VOLUME_NAME to /volume-data" "$CONTAINER_ID" "$IMAGE_NAME"
        docker container rm "$CONTAINER_ID"
        echo "Successfully copied volume $VOLUME_NAME into image $IMAGE_NAME, under /volume-data"
    end
end

function vackup-load
    set VOLUME_NAME (docker volume ls | fzf | hck -f2 | tr -d "\n")
    set IMAGE_NAME (docker images | fzf | hck -f3 | tr -d "\n")
    if [ "$VOLUME_NAME" ]; and [ "$IMAGE_NAME" ]
        docker volume rm "$VOLUME_NAME"
        docker volume create "$VOLUME_NAME"
        docker run --rm \
            -v "$VOLUME_NAME":/mount-volume \
            "$IMAGE_NAME" \
            cp -Rp /volume-data/. /mount-volume/

        echo "Successfully copied /volume-data from $IMAGE_NAME into volume $VOLUME_NAME"
    end
end

function vackup
    set action (gum choose --header "Select action (↑↓, X to choose, enter to confirm)" \
    "🔍 Export" \
    "🔍 Bulk export" \
    "🔧 Import" \
    "🔧 Bulk import" \
    "📦 Save" \
    "⏹️ Load" #\
#    "🏁 Exit"
    )
    switch $action
        case '*Export'
            vackup-export
        case '*Bulk export'
            set prefix (gum input --placeholder "volumes name prefix")
            vackup-bulk-export $prefix
        case '*Import'
            vackup-import
        case '*Bulk import'
            set directories (ls -d */)
            set prefix (gum choose $directories)
            vackup-bulk-import $prefix
        case '*Save'
            vackup-save
        case '*Load'
            vackup-load
        case '*'
            echo nothing
    end
end
