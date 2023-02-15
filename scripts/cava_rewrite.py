import argparse
import os
import signal
import subprocess
import sys
import tempfile
from signal import SIG_DFL, SIGPIPE
from signal import signal as sf

# sf(SIGPIPE, SIG_DFL)
FifoPath = "/tmp/nvim_pipe"


class CavaRunner:
    def __init__(self, framerate, bars, channels, extra_colors):
        self.framerate = framerate
        self.bars = bars
        self.channels = channels
        self.extra_colors = extra_colors
        self.cava_conf = f"{FifoPath}.conf"

    def create_conf_file(self):
        conf_channels = ""
        if self.channels != "stereo":
            conf_channels = "channels=mono\n" f"mono_option={self.channels}"

        conf_ascii_max_range = 12 + len(
            [i for i in self.extra_colors.split(",") if i]
        )
        with open(self.cava_conf, "w") as cava_conf_file:
            cava_conf_file.write(
                "[general]\n"
                f"framerate={self.framerate}\n"
                f"bars={self.bars}\n"
                "[output]\n"
                "method=raw\n"
                "data_format=ascii\n"
                f"ascii_max_range={conf_ascii_max_range}\n"
                "bar_delimiter=32" + conf_channels
            )

    def run(self):
        cava_proc = subprocess.Popen(
            ["cava", "-p", self.cava_conf], stdout=subprocess.PIPE
        )
        self_proc = subprocess.Popen(
            ["python3", __file__, "--subproc", self.extra_colors],
            stdin=cava_proc.stdout,
        )

        # signal.signal(signal.SIGTERM, self.cleanup)
        # signal.signal(signal.SIGINT, self.cleanup)
        self_proc.wait()

    def cleanup(self, sig, frame):
        os.remove(self.cava_conf)
        os.remove(FifoPath)
        # sys.exit(0)

    def __call__(self):
        self.create_conf_file()
        self.run()


if len(sys.argv) > 1 and sys.argv[1] == "--subproc":
    ramp_list = [" ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]
    try:
        with open(FifoPath, "w") as fifo_write:
            while True:
                cava_input = input().strip().split()
                cava_input = [int(i) for i in cava_input]
                output = ""
                for bar in cava_input:
                    if bar < len(ramp_list):
                        output += ramp_list[bar]
                    else:
                        output += ramp_list[-1]

                fifo_write.write(f"{output}\n")
                fifo_write.flush()
    except IOError as e:
        pass
else:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f",
        "--framerate",
        type=int,
        default=240,
        help="Framerate to be used by cava, default is 240",
    )
    parser.add_argument(
        "-b",
        "--bars",
        type=int,
        default=20,
        help="Amount of bars, default is 20",
    )
    parser.add_argument(
        "-e",
        "--extra_colors",
        default="fdd,fcc,fbb,faa",
        help="Color gradient used on higher values, separated by commas, default is",
    )
    parser.add_argument(
        "-c",
        "--channels",
        choices=["stereo", "left", "right", "average"],
        help="Audio channels to be used, defaults to stereo",
    )
    opts = parser.parse_args()

    if not os.path.exists(FifoPath):
        os.mkfifo(FifoPath)

    cava_runner = CavaRunner(
        opts.framerate, opts.bars, opts.channels, opts.extra_colors
    )
    cava_runner()
