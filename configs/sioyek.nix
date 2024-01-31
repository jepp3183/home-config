{
  programs.sioyek = {
    enable = true;
    bindings = {
      next_page = "J";
      previous_page = "K";
      fit_to_page_height = "a";
      fit_to_page_height_smart = "A";
      fit_to_page_width = "s";
      fit_to_page_width_smart = "S";
      close_window = "q";
      goto_mark = "'";
      move_right = "h";
      move_left = "l";
      open_document_embedded = "o";
      prev_state = "<C-o>";
      next_state = "<C-i>";
    };
    config = {
      should_launch_new_window = "1";
    };
  };
}
