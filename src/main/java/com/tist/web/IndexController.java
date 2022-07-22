package com.tist.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * IndexController
 *
 * @author sungyeh
 */
@Controller
public class IndexController {

    @GetMapping("/index")
    public String index() {
        return "index";
    }

    @ResponseBody
    @GetMapping("/download/{id}")
    public String download(@PathVariable("id") String id) throws IOException {

        ByteArrayOutputStream byteArrayOutputStream = Download.downloadFile(id);
        try (OutputStream outputStream = new FileOutputStream("D:/test.mp4")) {
            byteArrayOutputStream.writeTo(outputStream);
        }
        return "test";
    }


    @RequestMapping("/test")
    public String info() throws IOException {

        return "/info";
    }
}
