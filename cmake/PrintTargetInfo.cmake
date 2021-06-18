cmake_minimum_required(VERSION 3.18)
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
        get_target_property(PROP_INC  ${target_name} INTERFACE_INCLUDE_DIRECTORIES)
        get_target_property(PROP_LIB  ${target_name} INTERFACE_LINK_LIBRARIES)
        get_target_property(PROP_OPT  ${target_name} INTERFACE_COMPILE_OPTIONS)
        get_target_property(PROP_DEF  ${target_name} INTERFACE_COMPILE_DEFINITIONS)
        get_target_property(PROP_FTR  ${target_name} INTERFACE_COMPILE_FEATURES)
        get_target_property(PROP_TYP  ${target_name} TYPE)
        get_target_property(PROP_IMP  ${target_name} IMPORTED)
        if(PROP_IMP)
            get_target_property(PROP_LOC  ${target_name} LOCATION)
        endif()

        if(${target_name} MATCHES "CONAN")
            remove_genexpr(PROP_INC)
            remove_genexpr(PROP_LIB)
            remove_genexpr(PROP_OPT)
            remove_genexpr(PROP_DEF)
            remove_genexpr(PROP_FTR)
        endif()

        pad_string(padded_target "32" " " "${prefix}[${target_name}]" )
        if(PROP_LIB)
            list(REMOVE_DUPLICATES PROP_LIB)
            message(STATUS "${padded_target} LIBRARY : ${PROP_LIB}" )
        endif()
        if(PROP_INC)
            list(REMOVE_DUPLICATES PROP_INC)
            message(STATUS "${padded_target} INCLUDE : ${PROP_INC}" )
        endif()
        if(PROP_OPT)
            list(REMOVE_DUPLICATES PROP_OPT)
            message(STATUS "${padded_target} OPTIONS : ${PROP_OPT}" )
        endif()
        if(PROP_DEF)
            list(REMOVE_DUPLICATES PROP_DEF)
            message(STATUS "${padded_target} DEFINES : ${PROP_DEF}" )
        endif()
        if(PROP_FTR)
            message(STATUS "${padded_target} FEATURE : ${PROP_FTR}" )
        endif()
        if(PROP_LOC)
            message(STATUS "${padded_target} IMPORTS : ${PROP_LOC}" )
        endif()
    endif()
endfunction()
