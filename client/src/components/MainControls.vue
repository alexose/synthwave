<template>
    <div class="hello">
        <h1>Synthwave</h1>
    </div>
    <div class="device-list">
        <div
            v-for="(device, idx) in devices"
            :key="'device-' + idx"
            :class="['device', status[idx] ? 'active' : null]"
            @click="activate(device)"
        >
            {{ device.name }}
        </div>
    </div>
</template>

<script>
    export default {
        name: "MainControls",
        methods: {
            activate: async function (device) {
                this.status[device.key] = "running";
                let params = {};

                if (device.locking) {
                    params.lock = true;
                } else {
                    params.duration = 1;
                }

                const url = new URL(`/api/device/${device.key.toLowerCase()}`, window.location.origin);
                Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));

                try {
                    let response = await fetch(url, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: "",
                    });

                    this.status = await response.json();
                    console.log(this.status);
                } catch (error) {
                    console.error("Error:", error);
                }
            },
        },
        data() {
            return {
                status: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
            };
        },
    };
</script>

<style scoped>
    .device-list {
        display: grid;
        max-width: 500px;
        margin: 0 auto;
        grid-template-columns: repeat(2, 1fr); /* 2 columns that take up an equal fraction of the space */
        grid-template-rows: repeat(4, auto); /* 4 rows that adjust to the content height */
        gap: 16px; /* Space between grid items, adjust as necessary */
    }

    .device {
        border: 1px solid #eee;
        margin: 10px;
        padding: 20px;
        cursor: pointer;
    }

    .device.active {
        background: #eee;
    }
</style>
