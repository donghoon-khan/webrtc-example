package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DemoController {
    @RequestMapping("/hls")
    public String hls() {
        return "hls";
    }

    @RequestMapping("/webrtc")
    public String webrtc() {
        return "webrtc";
    }
}
