cmake_minimum_required(VERSION 3.12)

# h5pp requires the filesystem header (and possibly stdc++fs library)
find_package(Filesystem COMPONENTS Final Experimental)
if (TARGET std::filesystem)
    target_link_libraries(deps INTERFACE std::filesystem)
    list(APPEND H5PP_TARGETS std::filesystem)
elseif (H5PP_DOWNLOAD_METHOD MATCHES "fetch|conan")
    message(STATUS "Your compiler lacks std::filesystem. A drop-in replacement ghc::filesystem will be downloaded")
    message(STATUS "Read more about ghc::filesystem here: https://github.com/gulrak/filesystem")
    include(cmake/Fetch_ghcFilesystem.cmake)
    if(TARGET ghcFilesystem::ghc_filesystem)
        add_library(std::filesystem INTERFACE IMPORTED)
        target_link_libraries(std::filesystem INTERFACE ghcFilesystem::ghc_filesystem)
        target_link_libraries(deps INTERFACE std::filesystem)
        list(APPEND H5PP_TARGETS std::filesystem)
    endif()
else()
    message(STATUS "Your compiler lacks std::filesystem. Set H5PP_DOWNLOAD_METHOD to 'fetch' or 'conan' or to get the ghc::filesystem replacement")
    message(STATUS "Read more about ghc::filesystem here: https://github.com/gulrak/filesystem")
    message(FATAL_ERROR "<filesystem> header and/or library not found")
endif()




if(H5PP_DOWNLOAD_METHOD MATCHES "find")
    if(NOT H5PP_DOWNLOAD_METHOD MATCHES "fetch")
        set(REQUIRED ${REQUIRED})
    endif()
    # Start finding the dependencies
    if(H5PP_ENABLE_EIGEN3 AND NOT TARGET Eigen3::Eigen )
        find_package(Eigen3 3.3.4 ${REQUIRED})
        if(TARGET Eigen3::Eigen)
            list(APPEND H5PP_TARGETS Eigen3::Eigen)
            target_link_libraries(deps INTERFACE Eigen3::Eigen)
        endif()
    endif()

    if(H5PP_ENABLE_SPDLOG AND NOT TARGET spdlog::spdlog)
        # We don't need to find fmt here because
        # spdlog will try to find it in its config script
        find_package(spdlog 1.3.1 ${REQUIRED})
        if(TARGET spdlog)
            add_library(spdlog::spdlog ALIAS spdlog)
        endif()
        if(TARGET spdlog::spdlog)
            list(APPEND H5PP_TARGETS spdlog::spdlog)
            target_link_libraries(deps INTERFACE spdlog::spdlog)
        endif()
    endif()

    if (NOT TARGET hdf5::hdf5)
        find_package(HDF5 1.8 COMPONENTS C HL ${REQUIRED})
        if(TARGET hdf5::hdf5)
            list(APPEND H5PP_TARGETS hdf5::hdf5)
            target_link_libraries(deps INTERFACE hdf5::hdf5)
        endif()
    endif()
endif()