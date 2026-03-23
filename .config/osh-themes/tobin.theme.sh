#! bash oh-my-bash.module

SCM_THEME_PROMPT_PREFIX=" ${_omb_prompt_white}on ${_omb_prompt_purple}"
SCM_THEME_PROMPT_SUFFIX="${_omb_prompt_normal}"
SCM_THEME_PROMPT_DIRTY=" ${_omb_prompt_bold_red}✗"
SCM_THEME_PROMPT_CLEAN=" ${_omb_prompt_bold_green}✓"

function _omb_theme_venv {
  [[ $VIRTUAL_ENV ]] && _omb_util_print "${_omb_prompt_bold_yellow}(${VIRTUAL_ENV##*/})${_omb_prompt_normal} "
}

function _omb_theme_PROMPT_COMMAND {
  local venv git dir

  venv=$(_omb_theme_venv)
  git=$(scm_prompt_info)
  dir="${_omb_prompt_bold_blue}\W${_omb_prompt_normal}"

  PS1="${venv}${dir}${git} ${_omb_prompt_bold_white}❯${_omb_prompt_normal} "
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
