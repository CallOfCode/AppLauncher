
include(${TEST_SOURCE_DIR}/AppLauncherTestMacros.cmake)
include(${TEST_BINARY_DIR}/AppLauncherTestPrerequisites.cmake)


function(applauncher_test_launcher_overwrite_settings_test_case
  testcase_id

  LauncherNoSplashScreen
  user_additional_LauncherNoSplashScreen
  cmdarg_additional_LauncherNoSplashScreen
  expected_LauncherNoSplashScreen

  LauncherSplashScreenHideDelayMs
  user_additional_LauncherSplashScreenHideDelayMs
  cmdarg_additional_LauncherSplashScreenHideDelayMs
  expected_LauncherSplashScreenHideDelayMs

  LauncherSplashImagePath
  user_additional_LauncherSplashImagePath
  cmdarg_additional_LauncherSplashImagePath
  expected_LauncherSplashImagePath

  UserAdditionalSettingsFileBaseName
  user_additional_UserAdditionalSettingsFileBaseName
  cmdarg_additional_UserAdditionalSettingsFileBaseName
  expected_UserAdditionalSettingsFileBaseName

  AdditionalLauncherHelpShortArgument
  user_additional_AdditionalLauncherHelpShortArgument
  cmdarg_additional_AdditionalLauncherHelpShortArgument
  expected_AdditionalLauncherHelpShortArgument

  AdditionalLauncherHelpLongArgument
  user_additional_AdditionalLauncherHelpLongArgument
  cmdarg_additional_AdditionalLauncherHelpLongArgument
  expected_AdditionalLauncherHelpLongArgument

  AdditionalLauncherNoSplashArguments
  user_additional_AdditionalLauncherNoSplashArguments
  cmdarg_additional_AdditionalLauncherNoSplashArguments
  expected_AdditionalLauncherNoSplashArguments
  )

  set(key_LauncherNoSplashScreen "launcherNoSplashScreen")
  set(key_LauncherSplashScreenHideDelayMs "launcherSplashScreenHideDelayMs")
  set(key_LauncherSplashImagePath "launcherSplashImagePath")
  set(key_UserAdditionalSettingsFileBaseName "userAdditionalSettingsFileBaseName")
  set(key_AdditionalLauncherHelpShortArgument "additionalLauncherHelpShortArgument")
  set(key_AdditionalLauncherHelpLongArgument "additionalLauncherHelpLongArgument")
  set(key_AdditionalLauncherNoSplashArguments "additionalLauncherNoSplashArguments")

  foreach(setting
    LauncherNoSplashScreen
    LauncherSplashScreenHideDelayMs
    LauncherSplashImagePath
    UserAdditionalSettingsFileBaseName
    AdditionalLauncherHelpShortArgument
    AdditionalLauncherHelpLongArgument
    AdditionalLauncherNoSplashArguments
    )

    if(NOT ${setting} STREQUAL "NA")
      set(${setting}_set "${key_${setting}}=${${setting}}")
    endif()
    if(NOT cmdarg_additional_${setting} STREQUAL "NA")
      set(cmdarg_additional_${setting}_set "${key_${setting}}=${cmdarg_additional_${setting}}")
    endif()
    if(NOT user_additional_${setting} STREQUAL "NA")
      set(user_additional_${setting}_set "${key_${setting}}=${user_additional_${setting}}")
    endif()

  endforeach()

  if(NOT DEFINED AdditionalSettingsExcludeGroups_set)
    message(FATAL_ERROR "AdditionalSettingsExcludeGroups_set should be set")
  endif()

  # Configure settings file
  set(organization_domain "www.commontk-${TEST_TREE_TYPE}.org")
  set(organization_name "Common ToolKit ${TEST_TREE_TYPE}")
  set(application_name "AppLauncher")
  set(application_revision "4810")
  set(launcherSplashScreenHideDelayMs "1")
  file(WRITE "${launcher}LauncherSettings.ini" "
[General]
${LauncherNoSplashScreen_set}
${LauncherSplashScreenHideDelayMs_set}
${LauncherSplashImagePath_set}
${UserAdditionalSettingsFileBaseName_set}
${AdditionalLauncherHelpShortArgument_set}
${AdditionalLauncherHelpLongArgument_set}
${AdditionalLauncherNoSplashArguments_set}
${AdditionalSettingsExcludeGroups_set}

[Application]
path=${application}
organizationDomain=${organization_domain}
organizationName=${organization_name}
name=${application_name}
revision=${application_revision}

[LibraryPaths]
1\\path=${library_path}
size=1
")

  # Extract application settings directory
  extract_application_settings_value("UserAdditionalSettingsDir" user_additional_settings_dir)
  set(user_additional_settings_path "${user_additional_settings_dir}/${application_name}${UserAdditionalSettingsFileBaseName}-${application_revision}.ini")

  # Configure user additional settings file
  file(WRITE ${user_additional_settings_path} "
[General]
${user_additional_LauncherNoSplashScreen_set}
${user_additional_LauncherSplashScreenHideDelayMs_set}
${user_additional_LauncherSplashImagePath_set}
${user_additional_UserAdditionalSettingsFileBaseName_set}
${user_additional_AdditionalLauncherHelpShortArgument_set}
${user_additional_AdditionalLauncherHelpLongArgument_set}
${user_additional_AdditionalLauncherNoSplashArguments_set}
")

  # Configure additional settings file
  set(cmdarg_additional_settings_path "${launcher}AdditionalLauncherSettings.ini")
  file(WRITE ${cmdarg_additional_settings_path} "
[General]
${cmdarg_additional_LauncherNoSplashScreen_set}
${cmdarg_additional_LauncherSplashScreenHideDelayMs_set}
${cmdarg_additional_LauncherSplashImagePath_set}
${cmdarg_additional_UserAdditionalSettingsFileBaseName_set}
${cmdarg_additional_AdditionalLauncherHelpShortArgument_set}
${cmdarg_additional_AdditionalLauncherHelpLongArgument_set}
${cmdarg_additional_AdditionalLauncherNoSplashArguments_set}
")

  # Check if launcher works as expected
  foreach(setting
      LauncherNoSplashScreen
      LauncherSplashScreenHideDelayMs
      LauncherSplashImagePath
      UserAdditionalSettingsFileBaseName
      AdditionalLauncherHelpShortArgument
      AdditionalLauncherHelpLongArgument
      AdditionalLauncherNoSplashArguments
      )

    extract_application_settings_value("${setting}" current_${setting} --launcher-additional-settings ${cmdarg_additional_settings_path})
    if(NOT "${current_${setting}}" STREQUAL "${expected_${setting}}")
      message(FATAL_ERROR "TestCase: ${testcase_id}\n"
                          "expected_${setting} [${expected_${setting}}]\n"
                          "current_${setting} [${current_${setting}}]")
    endif()

  endforeach()

  # Clean
  file(REMOVE ${user_additional_settings_path})
endfunction()

# --------------------------------------------------------------------------
# Debug flags - Set to True to display the command as string
set(PRINT_COMMAND 0)

#
# Without excluding additional settings groups
#

set(AdditionalSettingsExcludeGroups_set "")

applauncher_test_launcher_overwrite_settings_test_case(
  "1" # testcase_id
  "1" "1" "0" "0" # LauncherNoSplashScreen
  "1" "2" "3" "3" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "/home/path/image2.png" "/home/path/image3.png" "/home/path/image3.png" # LauncherSplashImagePath
  "Foo1Settings" "Foo2Settings" "Foo3Settings" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "-h2" "-h3" "-h3" # AdditionalLauncherHelpShortArgument
  "--help1" "--help2" "--help3" "--help3" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "--foo2,-b2" "--foo3,-b3" "--foo1,-b1,--foo2,-b2,--foo3,-b3" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "2" # testcase_id
  "1" "0" "NA" "0" # LauncherNoSplashScreen
  "1" "2" "NA" "2" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "/home/path/image2.png" "NA" "/home/path/image2.png" # LauncherSplashImagePath
  "Foo1Settings" "Foo2Settings" "NA" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "-h2" "NA" "-h2" # AdditionalLauncherHelpShortArgument
  "--help1" "--help2" "NA" "--help2" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "--foo2,-b2" "NA" "--foo1,-b1,--foo2,-b2" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "3" # testcase_id
  "1" "NA" "NA" "1" # LauncherNoSplashScreen
  "1" "NA" "NA" "1" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "NA" "NA" "/home/path/image1.png" # LauncherSplashImagePath
  "Foo1Settings" "NA" "NA" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "NA" "NA" "-h1" # AdditionalLauncherHelpShortArgument
  "--help1" "NA" "NA" "--help1" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "NA" "NA" "--foo1,-b1" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "4" # testcase_id
  "NA" "NA" "NA" "0" # LauncherNoSplashScreen
  "NA" "NA" "NA" "800" # LauncherSplashScreenHideDelayMs
  "NA" "NA" "NA" ":Images/ctk-splash.png" # LauncherSplashImagePath
  "NA" "NA" "NA" "" # UserAdditionalSettingsFileBaseName
  "NA" "NA" "NA" "" # AdditionalLauncherHelpShortArgument
  "NA" "NA" "NA" "" # AdditionalLauncherHelpLongArgument
  "NA" "NA" "NA" "" # AdditionalLauncherNoSplashArguments
  )

#
# Excluding additional settings groups: General
#

set(AdditionalSettingsExcludeGroups_set "additionalSettingsExcludeGroups=General")

applauncher_test_launcher_overwrite_settings_test_case(
  "5" # testcase_id
  "1" "1" "0" "1" # LauncherNoSplashScreen
  "1" "2" "3" "1" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "/home/path/image2.png" "/home/path/image3.png" "/home/path/image1.png" # LauncherSplashImagePath
  "Foo1Settings" "Foo2Settings" "Foo3Settings" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "-h2" "-h3" "-h1" # AdditionalLauncherHelpShortArgument
  "--help1" "--help2" "--help3" "--help1" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "--foo2,-b2" "--foo3,-b3" "--foo1,-b1" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "6" # testcase_id
  "1" "0" "NA" "1" # LauncherNoSplashScreen
  "1" "2" "NA" "1" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "/home/path/image2.png" "NA" "/home/path/image1.png" # LauncherSplashImagePath
  "Foo1Settings" "Foo2Settings" "NA" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "-h2" "NA" "-h1" # AdditionalLauncherHelpShortArgument
  "--help1" "--help2" "NA" "--help1" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "--foo2,-b2" "NA" "--foo1,-b1" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "7" # testcase_id
  "1" "NA" "NA" "1" # LauncherNoSplashScreen
  "1" "NA" "NA" "1" # LauncherSplashScreenHideDelayMs
  "/home/path/image1.png" "NA" "NA" "/home/path/image1.png" # LauncherSplashImagePath
  "Foo1Settings" "NA" "NA" "Foo1Settings" # UserAdditionalSettingsFileBaseName
  "-h1" "NA" "NA" "-h1" # AdditionalLauncherHelpShortArgument
  "--help1" "NA" "NA" "--help1" # AdditionalLauncherHelpLongArgument
  "--foo1,-b1" "NA" "NA" "--foo1,-b1" # AdditionalLauncherNoSplashArguments
  )

applauncher_test_launcher_overwrite_settings_test_case(
  "8" # testcase_id
  "NA" "NA" "NA" "0" # LauncherNoSplashScreen
  "NA" "NA" "NA" "800" # LauncherSplashScreenHideDelayMs
  "NA" "NA" "NA" ":Images/ctk-splash.png" # LauncherSplashImagePath
  "NA" "NA" "NA" "" # UserAdditionalSettingsFileBaseName
  "NA" "NA" "NA" "" # AdditionalLauncherHelpShortArgument
  "NA" "NA" "NA" "" # AdditionalLauncherHelpLongArgument
  "NA" "NA" "NA" "" # AdditionalLauncherNoSplashArguments
  )
