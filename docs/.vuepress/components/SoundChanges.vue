<template>
    <div class="sc-wrap">
        <label class="demo-label" for="sound-rule">Rule</label>
        <input id="sound-rule" v-model="rule" type="text" placeholder="t > d / V_V" class="demo-input sc-input" />

        <label class="demo-label" for="sound-input">Input</label>
        <input id="sound-input" v-model="inputStr" type="text" placeholder="ata" class="demo-input sc-input" />

        <p class="sc-result">
            <strong>Result:</strong> {{ result }}
        </p>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const API_URL = 'https://api-ph.foundry.owlbeardm.com/api'

const rule = ref('')
const inputStr = ref('')
const result = ref('')

const update = async () => {
    if (!rule.value || !inputStr.value) {
        result.value = ''
        return
    }

    try {
        const response = await fetch(`${API_URL}/rules/apply`, {
            method: 'POST',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'text/plain',
            },
            body: JSON.stringify({
                rule: rule.value,
                str: inputStr.value,
            }),
        })

        result.value = await response.text()
    } catch (err) {
        result.value = 'Request failed'
    }
}

watch([rule, inputStr], update)
</script>

<style>
.sc-wrap {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin: 10px;
}

.sc-input {
    max-width: 420px;
}

.sc-result {
    min-height: 24px;
    margin: 0;
}
</style>
