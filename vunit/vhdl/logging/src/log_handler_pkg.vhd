-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this file,
-- You can obtain one at http://mozilla.org/MPL/2.0/.
--
-- Copyright (c) 2017, Lars Asplund lars.anders.asplund@gmail.com

use work.integer_vector_ptr_pkg.all;
use work.log_levels_pkg.all;

package log_handler_pkg is

  type log_format_t is (
    -- The raw log format contains just the message without any other information
    raw,

    -- The level log format contains the level and message
    level,

    -- The verbose log format contains all information
    verbose,

    -- The csv format contains all information in machine readable format
    csv);

  -- Log handler record, all fields are private
  type log_handler_t is record
    p_data : integer_vector_ptr_t;
  end record;
  constant null_handler : log_handler_t := (p_data => null_ptr);
  type log_handler_vec_t is array (natural range <>) of log_handler_t;

  -- Display handler; Write to stdout
  constant display_handler : log_handler_t;

  -- File handler; Write to file
  -- Is configured to output_path/log.csv by test_runner_setup
  constant file_handler : log_handler_t;

  -- Set the format to be used by the log handler
  procedure set_format(log_handler : log_handler_t;
                       format : log_format_t;
                       use_color : boolean := false);

  ---------------------------------------------
  -- Private parts not intended for public use
  ---------------------------------------------
  impure function get_id(log_handler : log_handler_t) return natural;
  procedure update_max_logger_name_length(log_handler : log_handler_t; value : natural);
  impure function get_max_logger_name_length(log_handler : log_handler_t) return natural;

  procedure log_to_handler(log_handler : log_handler_t;
                           logger_name : string;
                           msg : string;
                           log_level : log_level_t;
                           log_time : time;
                           line_num : natural := 0;
                           file_name : string := "");

  impure function new_log_handler(file_name : string;
                                  format : log_format_t;
                                  use_color : boolean) return log_handler_t;

  procedure init_log_handler(log_handler : log_handler_t;
                             format : log_format_t;
                             file_name : string;
                             use_color : boolean := false);
end package;
