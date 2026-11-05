#!/usr/bin/env python3
"""Report independent observations; never infer mirroring from discovery."""
import argparse
import json
from pathlib import Path


def analyze(log):
    return {
        "mdns_registered_locally": "MDNS_REGISTERED" in log,
        "client_transport_connected": "CLIENT_CONNECTED (transport only)" in log,
        "video_packet_received": "VIDEO_PACKET_RECEIVED" in log,
        "frame_rendered_callback": "VIDEO_FRAME_RENDERED" in log,
        "visual_content_verified": False,
        "fire_tv_compatibility": "Requires visual test on target hardware",
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path)
    args = parser.parse_args()
    print(json.dumps(analyze(args.log.read_text(errors="replace")), indent=2))
