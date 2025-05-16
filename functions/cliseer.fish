function cliseer
    mkdir -p $CLISEER_LOG_DIR/stdout/
    set output_file $CLISEER_LOG_DIR/stdout/$__command_key
    echo $__fish_last_cmd > $output_file
    echo "==============" >> $output_file
    tee -a $output_file
 end
