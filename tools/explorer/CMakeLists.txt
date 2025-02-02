include(ExternalProject)

set(TT_EXPLORER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/run.py)
set(TTMLIR_BUILD_BIN_DIR ${TTMLIR_BINARY_DIR}/bin)

set(MODEL_EXPLORER_VERSION "95d79ec933643c3b145537ce6fd5d9f0e735683d")
ExternalProject_Add(
  model-explorer
  PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/model-explorer
  GIT_REPOSITORY https://github.com/tenstorrent/model-explorer.git
  GIT_TAG ${MODEL_EXPLORER_VERSION}
  GIT_PROGRESS ON
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)

add_custom_target(explorer
  COMMENT "Building tt-explorer... ${TTMLIR_BIN_DIR}"
  COMMAND pip install $<$<CONFIG:Debug>:-e> ${CMAKE_CURRENT_SOURCE_DIR}/tt_adapter
  COMMAND pip install ${CMAKE_CURRENT_SOURCE_DIR}/model-explorer/src/model-explorer/src/server/package

  DEPENDS TTMLIRPythonModules model-explorer ttrt
)

add_custom_command(TARGET explorer POST_BUILD
  COMMENT "Installing tt-explorer command..."
  COMMAND ${CMAKE_COMMAND} -E create_symlink ${TT_EXPLORER_SCRIPT} ${TTMLIR_BUILD_BIN_DIR}/tt-explorer
  COMMAND ${CMAKE_COMMAND} -E echo "Done. Run: tt-explorer to start the server."
)
