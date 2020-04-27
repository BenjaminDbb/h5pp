function(pad_string OUT_VARIABLE DESIRED_LENGTH FILL_CHAR VALUE)
    string(LENGTH "${VALUE}" VALUE_LENGTH)
    math(EXPR REQUIRED_PADS "${DESIRED_LENGTH} - ${VALUE_LENGTH}")
    set(PAD ${VALUE})
    if(REQUIRED_PADS GREATER 0)
        math(EXPR REQUIRED_MINUS_ONE "${REQUIRED_PADS} - 1")
        foreach(FOO RANGE ${REQUIRED_MINUS_ONE})
            set(PAD "${PAD}${FILL_CHAR}")
        endforeach()
    endif()
    set(${OUT_VARIABLE} "${PAD}" PARENT_SCOPE)
endfunction()

function(remove_genexpr list_data)
#    message("list_data ${list_data} | ${${list_data}}")
    foreach(elem ${${list_data}})
#        message(${elem})
        if(${elem} MATCHES "CONAN_LIB::" OR ${elem} MATCHES ".conan")
            list(APPEND match_list ${elem})
        elseif(${elem} MATCHES "$<" OR ${elem} MATCHES ">" )
#            message("Discarding: ${elem}")
        else()
            list(APPEND match_list ${elem})
        endif()
    endforeach()
    set(${list_data} ${match_list} PARENT_SCOPE)
endfunction()

function(print_target_info target_name prefix)
    if(TARGET ${target_name})
        get_target_property(INFO_INC  ${target_name} INTERFACE_INCLUDE_DIRECTORIES)
        get_target_property(INFO_LIB  ${target_name} INTERFACE_LINK_LIBRARIES)
        get_target_property(INFO_OPT  ${target_name} INTERFACE_COMPILE_OPTIONS)
        get_target_property(INFO_DEF  ${target_name} INTERFACE_COMPILE_DEFINITIONS)
        get_target_property(INFO_FTR  ${target_name} INTERFACE_COMPILE_FEATURES)
        get_target_property(TYPE_TGT  ${target_name} TYPE)
        if(NOT TYPE_TGT MATCHES "INTERFACE" AND NOT TYPE_TGT MATCHES "EXECUTABLE")
            get_target_property(INFO_LOC  ${target_name} LOCATION)
        endif()

        if(${target_name} MATCHES "CONAN")
            remove_genexpr(INFO_INC)
            remove_genexpr(INFO_LIB)
            remove_genexpr(INFO_OPT)
            remove_genexpr(INFO_DEF)
            remove_genexpr(INFO_FTR)
        endif()





        pad_string(padded_target "32" " " "${prefix}[${target_name}]" )
        if(INFO_LIB)
            list(REMOVE_DUPLICATES INFO_LIB)
            message(STATUS "${padded_target} LIBRARY : ${INFO_LIB}" )
        endif()
        if(INFO_INC)
            list(REMOVE_DUPLICATES INFO_INC)
            message(STATUS "${padded_target} INCLUDE : ${INFO_INC}" )
        endif()
        if(INFO_OPT)
            list(REMOVE_DUPLICATES INFO_OPT)
            message(STATUS "${padded_target} OPTIONS : ${INFO_OPT}" )
        endif()
        if(INFO_DEF)
            list(REMOVE_DUPLICATES INFO_DEF)
            message(STATUS "${padded_target} DEFINES : ${INFO_DEF}" )
        endif()
        if(INFO_FTR)
            message(STATUS "${padded_target} FEATURE : ${INFO_FTR}" )
        endif()
        if(INFO_LOC)
            message(STATUS "${padded_target} IMPORTS : ${INFO_LOC}" )
        endif()
    endif()
endfunction()
