{
  lib,
  stdenvNoCC,
  xcur2png,
  xcursorgen,
  imagemagick,
  python3,
  file,
  ...
}:

stdenvNoCC.mkDerivation {
  pname = "aventurine-cursor";
  version = "1.0";

  src = ./Aventurine.tar.gz;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-pd2OaK/wqMectm6lwAIG3v3STPCC8sC9Hp7GTKzkiTw=";

  nativeBuildInputs = [
    xcur2png
    xcursorgen
    imagemagick
    python3
    file
  ];

  buildPhase = ''
    # bash
    cat > multisize.py <<EOF
    # python
    import os, subprocess, shutil, glob, sys, stat

    SCALES  = [2.0, 3.0]
    SRC_DIR = os.path.abspath("cursors")
    OUT_DIR = os.path.abspath("cursors_combined")

    if os.path.exists(OUT_DIR):
        shutil.rmtree(OUT_DIR)
    os.makedirs(OUT_DIR)

    def make_writable(path):
        if os.path.exists(path):
            st = os.stat(path)
            os.chmod(path, st.st_mode | stat.S_IWRITE)

    for cursor_path in glob.glob(os.path.join(SRC_DIR, "*")):
        cursor_name = os.path.basename(cursor_path)
        target_path = os.path.join(OUT_DIR, cursor_name)

        # 1. SKIP SYMLINKS
        if os.path.islink(cursor_path):
            link_target = os.readlink(cursor_path)
            os.symlink(link_target, target_path)
            continue

        # 2. FILTER JUNK
        if not os.path.isfile(cursor_path): continue
        if cursor_name.endswith(('.conf', '.theme', '.png', '.svg', '.txt')):
            continue

        # 3. VERIFY FILE TYPE
        file_type = subprocess.check_output(["file", "-b", cursor_path]).decode().strip()
        if "X11 cursor" not in file_type and "data" not in file_type:
            print(f"Skipping {cursor_name} (Type: {file_type})")
            shutil.copy(cursor_path, target_path)
            continue

        work_dir = os.path.abspath(f"work_{cursor_name}")
        if os.path.exists(work_dir): shutil.rmtree(work_dir)
        os.makedirs(work_dir)

        print(f"Processing {cursor_name}...")

        try:
            conf_out_file = os.path.join(work_dir, "extracted.conf")

            # 4. DECOMPILE
            subprocess.run(
                ["xcur2png", "-d", work_dir, "-c", conf_out_file, cursor_path],
                check=True, stdout=subprocess.DEVNULL
            )

            with open(conf_out_file, 'r') as f:
                lines = f.readlines()

            final_conf_lines = []

            # 5. PARSE & SCALE LOOP
            for line in lines:
                parts = line.split()
                if len(parts) < 4 or not parts[0].isdigit(): 
                    continue
                
                orig_size = int(parts[0])
                orig_xhot = int(parts[1])
                orig_yhot = int(parts[2])
                raw_filename = parts[3]
                rest = " ".join(parts[4:])
                
                # Resolve Image Path
                if os.path.isabs(raw_filename):
                    src_img_abs = raw_filename
                else:
                    src_img_abs = os.path.join(work_dir, raw_filename)
                
                base_filename = os.path.basename(raw_filename)
                
                # -- LAYER 1: Original (32px) --
                final_conf_lines.append(f"{orig_size} {orig_xhot} {orig_yhot} {src_img_abs} {rest}")
                
                # -- LAYER 2+: Generated Scales --
                for scale in SCALES:
                    new_size = int(orig_size * scale)
                    new_xhot = int(orig_xhot * scale)
                    new_yhot = int(orig_yhot * scale)
                    
                    # Unique filename for this scale
                    scale_str = str(scale).replace(".", "_")
                    new_filename = f"scaled_{scale_str}_{base_filename}"
                    dst_img_abs = os.path.join(work_dir, new_filename)
                    
                    if os.path.exists(src_img_abs):
                        shutil.copy(src_img_abs, dst_img_abs)
                        make_writable(dst_img_abs)
                        
                        # We use -scale (Nearest Neighbor) for pixel-art
                        scale_percent = f"{int(scale * 100)}%"
                        subprocess.run(["mogrify", "-scale", scale_percent, dst_img_abs], check=True)
                        
                        final_conf_lines.append(f"{new_size} {new_xhot} {new_yhot} {dst_img_abs} {rest}")

            # Write Config
            new_conf_path = os.path.join(work_dir, "gen.conf")
            with open(new_conf_path, "w") as f:
                f.write("\n".join(final_conf_lines) + "\n")
                
            # Compile
            subprocess.run(["xcursorgen", new_conf_path, target_path], check=True)

        except Exception as e:
            print(f"FAILED processing {cursor_name}: {e}")
            sys.exit(1)
            
        finally:
            if os.path.exists(work_dir): shutil.rmtree(work_dir)

    EOF

    # bash
    python3 multisize.py

    rm -rf cursors
    mv cursors_combined cursors
  '';

  installPhase = ''
    # bash
    mkdir -p $out/share/icons/Aventurine
    cp -r * $out/share/icons/Aventurine/
    chmod -R 644 $out/share/icons/Aventurine/cursors/*
    chmod a+x $out/share/icons/Aventurine/cursors
  '';

  meta = with lib; {
    description = "Aventurine Cursor Theme";
    platforms = platforms.all;
  };
}
