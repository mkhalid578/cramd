cmake_minimum_required(VERSION 3.16)

project(cramd VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Network Quick)

qt_standard_project_setup(REQUIRES 6.10)

# Content of downloaded design from Figma to Qt or similar
if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
        add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(cramd-app
        main.cpp
)

include_directories(src/api)
include_directories(src/auth)
include_directories(src/cars)

set_source_files_properties(qml/CarMake.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(cramd-app
        URI cramd
        QML_FILES
        Main.qml
        qml/pages/LoginForm.qml
        qml/pages/LoginSuccessPage.qml
        qml/CarMake.qml

        SOURCES
        src/api/client.cpp
        src/api/client.h
        src/auth/AuthService.h
        src/auth/AuthService.cpp
        src/cars/CarsService.h
        src/cars/CarsService.cpp
        src/cars/CarsListModel.h
        src/cars/CarsListModel.cpp
        QML_FILES qml/pages/MainPage.qml
        QML_FILES qml/components/CarDelegate.qml
        RESOURCES qml/assets/RearLegroom.svg qml/assets/CramdLogo.svg
        QML_FILES qml/components/InfoPopup.qml
        QML_FILES qml/components/CarInfoPopup.qml
        QML_FILES qml/components/CustomTabButton.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(cramd-app PROPERTIES
        #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appcramd
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(cramd-app
        PRIVATE Qt6::Network Qt6::Quick
)

install(TARGETS cramd-app
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
