def remove_lines(filepath, ranges_to_remove):
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    # ranges_to_remove is a list of (start, end) inclusive, 1-indexed
    # convert to 0-indexed set of lines to delete
    lines_to_delete = set()
    for start, end in ranges_to_remove:
        for i in range(start - 1, end):
            lines_to_delete.add(i)
            
    with open(filepath, 'w') as f:
        for i, line in enumerate(lines):
            if i not in lines_to_delete:
                f.write(line)

ranges = [
    (57, 61),      # eqData
    (65, 65),      # accumulatedEqOut
    (71, 72),      # lastEqUpdate
    (91, 117),     # eqLightningAnim
    (135, 138),    # introSeparator, introEqHeader, introEqSliders, introPresets
    (164, 186),    # Separator, EQ header, EQ sliders, Presets animations
    (232, 258),    # applyPresetOptimistically
    (280, 280),    # if (!eqProc.running) eqProc.running = true;
    (306, 323),    # eqProc
    (951, 1433),   # Separator and EQ Layout
    (1438, 1471),  # PresetButton component
]

remove_lines('/home/hypr/hypr-rice/quickshell/music/MusicPopup.qml', ranges)
print("Done")
