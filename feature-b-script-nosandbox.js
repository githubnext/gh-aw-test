#!/usr/bin/env node
function featureB() {
    console.log("Hello from Feature B (No Sandbox)!");
}

if (require.main === module) {
    featureB();
}
