<template>
    <div><small>{{ version }}</small></div>
</template>

<script setup async>
import { ref, watch } from 'vue'
let version = ref();

const update = () => {
    const requestOptions = {
        method: 'GET',
        mode: 'cors',
        headers: {
            "Content-Type": "text/plain",
            "Accept": "*/*",
        },
    };
    fetch("https://api-ph.foundry.owlbeardm.com/api/version", requestOptions)
        .then(response => response.json(), err => out.value = "")
        .then(data => {
            version.value = `Phonetic library version: ${data.version}`;
        });
}
update();
</script>
<style></style>
