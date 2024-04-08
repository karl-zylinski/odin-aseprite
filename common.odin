package aseprite_file_handler

destroy_doc :: proc(doc: ^Document) {
    destroy_value :: proc(p: UD_Property_Value) {
        #partial switch val in p {
        case UD_Vec:
            for v in val {
                destroy_value(v)
            }
            delete(val)

        case UD_Properties:
            for k, v in val {
                destroy_value(v)
            }
            delete(val)
        }
    }

    for frame in doc.frames {
        for chunk in frame.chunks {
            #partial switch v in chunk {
            case Old_Palette_256_Chunk:
                for pack in v {
                    delete(pack.colors)
                }
                delete(v)

            case Old_Palette_64_Chunk:
                for pack in v {
                    delete(pack.colors)
                }
                delete(v)

            case Layer_Chunk:
                // Badly frees???
                //delete(v.name)

            case Cel_Chunk:
                #partial switch cel in v.cel {
                    case Raw_Cel:
                        delete(cel.pixel)
                    case Com_Image_Cel:
                        delete(cel.pixel)
                    case Com_Tilemap_Cel:
                        delete(cel.tiles)
                }

            case Color_Profile_Chunk:
                if v.icc != nil {
                    delete(v.icc.(ICC_Profile))
                }

            case External_Files_Chunk:
                for e in v {
                    delete(e.file_name_or_id)
                }
                delete(v)
                
            case Mask_Chunk:
                delete(v.name)
                delete(v.bit_map_data)

            case Tags_Chunk:
                for tag in v {
                    delete(tag.name)
                }
                delete(v)

            case Palette_Chunk:
                for pal in v.entries {
                    switch n in pal.name {
                    case string:
                        delete(n)
                    }
                }
                delete(v.entries)

            case User_Data_Chunk:
                switch t in v.text {
                case string:
                    delete(t)
                }

                switch m in v.maps {
                case UD_Properties:
                    for _, val in m {
                        destroy_value(val)
                    }
                    delete(m)
                }

            case Slice_Chunk:
                delete(v.name)
                delete(v.keys)

            case Tileset_Chunk:
                delete(v.name)
                switch c in v.compressed {
                case Tileset_Compressed:
                    delete(c)
                }
            }
        }
        delete(frame.chunks)
    }
    delete(doc.frames)
}