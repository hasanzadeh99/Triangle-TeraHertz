# 
# Resynthesis initialization script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    set ::env(RT_TMP) "D:/Dropbox/Rodgel/Projects/1402/Triangle-TeraHertz/Triangle_Terahertz_FPGA_Ver4/Triangle_Terahertz_FPGA_Ver4.vhd/Triangle_Terahertz_FPGA_Ver4.vhd.runs/impl_1/.Xil/Vivado-5468-DESKTOP-IOGF5IK/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    source $::env(SYNTH_COMMON)/resynth_core.tcl
    set rt::defaultWorkLibName xil_defaultlib
    set ok_to_delete_rt_tmp true 

  } ; #end uplevel
} rt::result]
