<script lang="ts">
  import { onMount } from 'svelte';
  import { ModeWatcher } from "mode-watcher";
  import MainNav from "../components/Layouts/MainNav.svelte";
  import { Toaster } from "$lib/components/ui/sonner";
  export let ignoreStyles = false;

  //   // Force light mode on initial load
  onMount(() => {
    document.documentElement.classList.remove('dark');
    localStorage.setItem('theme', 'light'); // Ensure the theme is saved in local storage
  });
</script>

<ModeWatcher defaultMode="light" />
<Toaster />

<div>
  <main>
    <div class="'px-4 mx-auto max-w-7xl sm:px-8 py-4'">
      <MainNav />
    </div>
    <div class={ignoreStyles ? '' : 'px-4 mx-auto max-w-7xl sm:px-8 py-4'}>
      <slot ignoreStyles={ignoreStyles} />
    </div>
  </main>
</div>
