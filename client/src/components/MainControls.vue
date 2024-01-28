<template>
    <div class="hello">
        <h1>Synthwave</h1>
    </div>

    <span>Current Status: {{ getRoutineName(currentRoutine) }}</span>

    <div class="single-device">
        <div class="device">Begin Cycle</div>
    </div>

    <div class="sensors">
        <div
            v-for="(sensor, idx) in sensors"
            :key="'sensor-' + idx"
            :class="['sensor', sensorStatus[idx] ? 'active' : null]"
        >
            {{ sensor.name }}
            <div v-if="sensor.analog">Value: {{ sensorStatus[idx] }}</div>
        </div>
    </div>

    <span>Timestamp: {{ timestamp }}</span>

    <hr class="divider" />

    <details class="devices">
        <summary>
            <span class="title">Routines</span>
        </summary>
        <div class="device-list">
            <div
                v-for="(routine, idx) in routines"
                :key="'routine-' + idx"
                :class="['device', currentRoutine == routine.key ? 'active' : null, routine.class || null]"
                @click="activateRoutine(routine)"
            >
                {{ routine.name }}
            </div>
        </div>
    </details>

    <hr class="divider" />

    <details class="devices">
        <summary>
            <span class="title">Devices</span>
        </summary>
        <div class="device-list">
            <div
                v-for="(device, idx) in devices"
                :key="'device-' + idx"
                :class="[
                    'device',
                    deviceStatus[idx] && !device.analog ? 'active' : null,
                    device.disabled ? 'disabled' : null,
                    device.class ? device.class : null,
                ]"
                @click="device.disabled ? null : activateDevice(device)"
            >
                {{ device.name }}
                <div v-if="device.analog">Value: {{ deviceStatus[idx] }}</div>
            </div>
        </div>
    </details>
</template>

<script>
    export default {
        name: "MainControls",
        methods: {
            updateStatus() {
                fetch("/api/status")
                    .then(response => response.json())
                    .then(data => {
                        this.parseStatus(data);
                    })
                    .catch(error => {
                        console.error("Error fetching status:", error);
                    });
            },
            startPolling() {
                this.intervalId = setInterval(this.updateStatus, 1000);
            },
            stopPolling() {
                clearInterval(this.intervalId);
            },
            getRoutineName: function (key) {
                return this.routines.find(routine => routine.key == key)?.name || "Idle";
            },
            activateRoutine: async function (routine) {
                // If routine is already active, stop the routine
                if (this.currentRoutine == routine.key) {
                    const url = new URL(`/api/routine/stop`, window.location.origin);
                    this.post(url);
                    this.currentRoutine = "Idle";
                } else {
                    let params = {};
                    const url = new URL(`/api/routine/${routine.key.toLowerCase()}`, window.location.origin);
                    Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
                    this.post(url);
                }
            },
            parseStatus: function (data) {
                // The current routine is the first item in the array
                this.currentRoutine = data.shift();

                // The timestamp isthe second item
                this.timestamp = data.shift();

                // Then, the devices are the next 10 items
                this.deviceStatus = data.splice(0, 10);

                // The sensors are the remaining items
                this.sensorStatus = data;
            },

            activateDevice: async function (device) {
                this.deviceStatus[device.key] = "running";
                let params = {};

                if (device.locking) {
                    params.lock = true;
                } else {
                    params.duration = 1;
                }

                const url = new URL(`/api/device/${device.key.toLowerCase()}`, window.location.origin);
                Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
                this.post(url);
            },

            post: async function (url) {
                try {
                    let response = await fetch(url, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: "",
                    });

                    const data = await response.json();
                    this.parseStatus(data);
                } catch (error) {
                    console.error("Error:", error);
                }
            },
        },
        mounted() {
            this.startPolling();
        },
        beforeUnmount() {
            this.stopPolling();
        },
        data() {
            return {
                intervalId: null,
                currentRoutine: "Idle",
                deviceStatus: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                sensorStatus: [0, 0, 0, 0],
                timestamp: 0,
                routines: [
                    {
                        name: "Cycle Left",
                        key: "CYCLE1",
                    },
                    {
                        name: "Cycle Right",
                        key: "CYCLE2",
                    },
                    {
                        name: "Fill Left Container",
                        key: "FILL1",
                    },
                    {
                        name: "Fill Right Container",
                        key: "FILL2",
                    },
                    {
                        name: "Transfer Left to Right",
                        key: "TRANSFER1TO2",
                    },
                    {
                        name: "Transfer Right to Left",
                        key: "TRANSFER2TO1",
                    },
                    {
                        name: "Drain Left",
                        key: "DRAIN1",
                    },
                    {
                        name: "Drain Right",
                        key: "DRAIN2",
                    },
                    {
                        name: "Run Left Electrodes",
                        key: "ELECTRODE1",
                    },
                    {
                        name: "Run Right Electrodes",
                        key: "ELECTRODE2",
                    },
                    {
                        name: "Reverse Left Electrodes",
                        key: "ELECTRODE1_REVERSE",
                    },
                    {
                        name: "Reverse Right Electrodes",
                        key: "ELECTRODE2_REVERSE",
                    },
                ],
                devices: [
                    {
                        name: "Pump 1",
                        key: "PUMP1",
                    },
                    {
                        name: "Pump 2",
                        key: "PUMP2",
                    },
                    {
                        name: "Vaccuum 1",
                        key: "VAC1",
                    },
                    {
                        name: "Vaccuum 2",
                        key: "VAC2",
                    },
                    {
                        name: "Valve 1",
                        key: "VALVE1",
                        locking: true,
                    },
                    {
                        name: "Valve 2",
                        key: "VALVE2",
                        locking: true,
                    },
                    {
                        name: "Valve 3",
                        key: "VALVE3",
                        locking: true,
                    },
                    {
                        name: "Valve 4",
                        key: "VALVE4",
                        locking: true,
                    },
                    {
                        name: "Release 1",
                        key: "RELEASE1",
                    },
                    {
                        name: "Release 2",
                        key: "RELEASE2",
                    },
                ],
                sensors: [
                    {
                        name: "Left Float",
                        key: "FLOAT1",
                    },
                    {
                        name: "Right Float",
                        key: "FLOAT2",
                    },
                    {
                        name: "Left PH sensor",
                        key: "PH1",
                        analog: true,
                    },
                    {
                        name: "Right PH sensor",
                        key: "PH2",
                        analog: true,
                    },
                ],
            };
        },
    };
</script>

<style scoped>
    .device-list {
        display: grid;
        max-width: 500px;
        margin: 20px auto;
        grid-template-columns: repeat(2, 1fr); /* 2 columns that take up an equal fraction of the space */
        grid-template-rows: repeat(4, auto); /* 4 rows that adjust to the content height */
        gap: 16px; /* Space between grid items, adjust as necessary */
    }

    .single-device {
        width: 300px;
        margin: 40px auto 0;
    }

    .device {
        border: 1px solid #ddd;
        border-radius: 5px;
        margin: 10px;
        padding: 20px;
        cursor: pointer;
    }

    .device.active {
        background: #eee;
    }

    .device.disabled {
        cursor: auto;
    }

    .divider {
        margin: 40px auto;
        max-width: 500px;
        border-top: 1px solid #eee;
    }

    .sensors {
        display: grid;
        max-width: 500px;
        margin: 20px auto;
        grid-template-columns: repeat(2, 1fr);
        grid-template-rows: repeat(2, auto);
        gap: 16px;
    }

    .sensor {
        padding: 5px 20px;
    }

    .sensor {
        opacity: 0.35;
    }

    .sensor.active {
        opacity: 1;
    }

    .devices {
        margin-top: 40px;
    }

    .title {
        font-size: 1.2em;
        font-weight: bold;
        cursor: pointer;
    }
</style>
