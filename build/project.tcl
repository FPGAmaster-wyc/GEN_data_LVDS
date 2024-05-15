set projName data_gen_lvds	
set part xc7a35tfgg484-2	
set top top	
set tb_top tb_top

proc run_create {} {
    global projName
    global part
    global top
    global tb_top

    set outputDir ./$projName			

    file mkdir $outputDir

    create_project $projName $outputDir -part $part -force		

    set projDir [get_property directory [current_project]]

    add_files -fileset [current_fileset] -force -norecurse {
        ../src/gen_uart_data.v
        ../src/top.v
        ../src/uart_rx.v
        ../src/uart_tx.v
    }
	
    add_files -fileset [current_fileset] -force -norecurse {
        ../ip/clk_wiz_0.xcix
		../ip/ila_0.xcix
    }

    add_files -fileset [get_filesets sim_1] -force -norecurse {
        ../src/tb_top.v
    }

    add_files -fileset [current_fileset -constrset] -force -norecurse {
        ../src/top.xdc
    }

    source {../bd/bd.tcl}

    set_property top $tb_top [get_filesets sim_1]
    set_property top_lib xil_defaultlib [get_filesets sim_1]
    update_compile_order -fileset sim_1

    set_property top $top [current_fileset]
    set_property generic DEBUG=TRUE [current_fileset]

    set_property AUTO_INCREMENTAL_CHECKPOINT 1 [current_run -implementation]

    update_compile_order
}

proc run_build {} {         
    upgrade_ip [get_ips]

    # Synthesis
    launch_runs -jobs 12 [current_run -synthesis]
    wait_on_run [current_run -synthesis]

    # Implementation
    launch_runs -jobs 12 [current_run -implementation] -to_step write_bitstream
    wait_on_run [current_run -implementation]
}

