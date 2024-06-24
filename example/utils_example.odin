package example

import "core:log"
import "core:fmt"

import ase "../"
import "../utils"


// Convert first frame into an Image.
single_image :: proc() {
    data := #load("../tests/blob/geralt.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data[:], &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    img, img_err := utils.get_image(&doc)
    if img_err != nil {
        fmt.eprintln("Fail to get image:", img_err)
        return
    }
    defer utils.destroy(&img)
}


// Convert all frames into an Image.
all_images :: proc() {
    data := #load("../tests/blob/geralt.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data[:], &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    imgs, img_err := utils.get_all_images(&doc)
    if img_err != nil {
        fmt.eprintln("Fail to get all imags:", img_err)
        return
    }
    defer utils.destroy(imgs)
    
}


// Convert nth frame into Images.
nth_image :: proc() {
    data := #load("../tests/blob/marshmallow.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data[:], &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    img, img_err := utils.get_image(&doc, 7)
    if img_err != nil {
        fmt.eprintln("Fail to get image:", img_err)
        return
    }
    defer utils.destroy(&img)
}


// Create animation frames.
animation :: proc() {
    data := #load("../tests/blob/marshmallow.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data, &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    anim: utils.Animation
    anim_err := utils.get_animation(&doc, &anim)
    if anim_err != nil {
        fmt.eprintln("Fail to animation:", anim_err)
        return
    }
    defer utils.destroy(&anim)

}


// Create animation frames, only in tag.
animation_tag :: proc() {
    data := #load("../tests/blob/marshmallow.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data, &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    anim: utils.Animation
    anim_err := utils.get_animation(&doc, &anim, "Squish")
    if anim_err != nil {
        fmt.eprintln("Fail to animation:", anim_err)
        return
    }
    defer utils.destroy(&anim)
}


// Create animation frames from bytes.
animation_images :: proc() {
    data := #load("../tests/blob/marshmallow.aseprite")
    doc: ase.Document
    defer ase.destroy_doc(&doc)

    _, doc_err := ase.unmarshal(data, &doc)
    if doc_err != nil {
        fmt.eprintln("Fail to unmarshal:", doc_err)
        return
    }

    imgs, img_err := utils.get_all_images_bytes(&doc)
    if img_err != nil {
        fmt.eprintln("Fail to get all imags:", img_err)
        return
    }
    defer utils.destroy(imgs)

    md := utils.get_metadata(doc.header)

    anim: utils.Animation
    anim_err := utils.get_animation(imgs, md, &anim)
    if anim_err != nil {
        fmt.eprintln("Fail to animation:", anim_err)
        return
    }
    defer utils.destroy(&anim)
}
