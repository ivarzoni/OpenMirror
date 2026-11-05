import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location(
    "analyze_log", Path(__file__).parents[1] / "scripts/analyze_log.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class EvidenceTests(unittest.TestCase):
    def test_discovery_is_not_mirroring(self):
        result = module.analyze("MDNS_REGISTERED\nCLIENT_CONNECTED (transport only)")
        self.assertTrue(result["mdns_registered_locally"])
        self.assertFalse(result["video_packet_received"])
        self.assertFalse(result["frame_rendered_callback"])
        self.assertFalse(result["visual_content_verified"])

    def test_packets_are_not_rendering(self):
        result = module.analyze("VIDEO_PACKET_RECEIVED")
        self.assertTrue(result["video_packet_received"])
        self.assertFalse(result["frame_rendered_callback"])

    def test_rendering_still_needs_visual_check(self):
        result = module.analyze("VIDEO_FRAME_RENDERED")
        self.assertTrue(result["frame_rendered_callback"])
        self.assertFalse(result["visual_content_verified"])

    def test_empty_capture_proves_nothing(self):
        result = module.analyze("")
        self.assertFalse(any(value for value in result.values() if isinstance(value, bool)))


if __name__ == "__main__":
    unittest.main()
