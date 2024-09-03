<script lang="ts">
  import { useForm, router } from '@inertiajs/svelte';
  import { Button } from "$lib/components/ui/button"

  function redirectToJob() {
    const jobPath = "/jobs/1";
    window.location.href = jobPath;
  }

  export let toggleNewForm; // Accept the toggleNewForm function as a prop

  let form = useForm({
    title: '',
    location: '',
    description: '',
    requirements: ''
  });

  async function submit() {
    await $form.post('/jobs');
    $form.reset();
    if (toggleNewForm) {
      toggleNewForm();
    }
  }

  function cancel() {
    $form.reset();
    if (toggleNewForm) {
      toggleNewForm();
    } else {
      router.visit('/jobs'); // Redirect to jobs page when cancel is clicked
    }
  }
</script>

<div class="max-w-xl p-8 mx-auto mb-24">
  <h1 class="mb-6 text-2xl font-bold">Buat Daftar Pekerjaan</h1>
  <form on:submit|preventDefault={submit}>

    <div class="mb-4">
      <label for="title" class="block mb-4 text-sm font-medium">Judul Pekerjaan</label>
      <input type="text" bind:value={$form.title} class="block w-full p-2 py-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm" />
      {#if $form.errors.title}
        <div class="form-error">{$form.errors.title}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="location" class="block mb-4 text-sm font-medium">Lokasi</label>
      <input type="text" bind:value={$form.location} class="block w-full p-2 py-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm" />
      {#if $form.errors.location}
        <div class="form-error">{$form.errors.location}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="description" class="block mb-4 text-sm font-medium">Deskripsi</label>
      <textarea bind:value={$form.description} class="block w-full p-2 py-2 pb-24 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"></textarea>
      {#if $form.errors.description}
        <div class="form-error">{$form.errors.description}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="requirements" class="block mb-4 text-sm font-medium">Persyaratan Pekerjaan</label>
      <textarea bind:value={$form.requirements} class="block w-full p-2 pt-2 pb-24 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"></textarea>
      {#if $form.errors.requirements}
        <div class="form-error">{$form.errors.requirements}</div>
      {/if}
    </div>

    <button type="submit" disabled={$form.processing}>Buat Perkerjaan
    </button>
    <button type="button" on:click={cancel}>Cancel</button>
  </form>
</div>
