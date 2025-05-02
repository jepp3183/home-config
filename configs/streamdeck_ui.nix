{ pkgs, config, input, ...}:
{
  home.file.".streamdeck_ui.json".text = /* json */''
     {
        "state": {
            "AL49J2C03127": {
                "buttons": {
                    "0": {
                        "0": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Dec",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "http POST 192.168.0.169:5000/decrement?step=25",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "1": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Inc",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "http POST 192.168.0.169:5000/increment?step=25",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "2": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "3": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "SPEAKER",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "pactl set-default-sink alsa_output.pci-0000_28_00.4.analog-stereo",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "4": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "HEADSET",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "pactl set-default-sink alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "5": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Toggle",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "http POST 192.168.0.169:5000/toggle",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "6": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Dim",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "http POST 192.168.0.169:5000/set temp==2700 brightness==80",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                },
                                "1": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "7": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Full",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "http POST 192.168.0.169:5000/set temp==2700 brightness==255",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "8": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "9": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "10": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Prev",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "playerctl previous",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "11": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Play/Pause",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "playerctl play-pause",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "12": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "Next",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "playerctl next",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "middle",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "13": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        },
                        "14": {
                            "state": 0,
                            "states": {
                                "0": {
                                    "text": "",
                                    "icon": "",
                                    "keys": "",
                                    "write": "",
                                    "command": "",
                                    "brightness_change": 0,
                                    "switch_page": 0,
                                    "switch_state": 0,
                                    "text_vertical_align": "",
                                    "text_horizontal_align": "",
                                    "font": "",
                                    "font_color": "",
                                    "font_size": 0,
                                    "background_color": ""
                                }
                            }
                        }
                    }
                },
                "display_timeout": 36000,
                "brightness": 100,
                "brightness_dimmed": 0,
                "rotation": 0,
                "page": 0
            }
        },
        "streamdeck_ui_version": 2
    } 
  '';
}
