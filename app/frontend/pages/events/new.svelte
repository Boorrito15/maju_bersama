<script lang="ts">
  import { useForm, router } from '@inertiajs/svelte';

  export let toggleNewForm; // Accept the toggleNewForm function as a prop

  let form = useForm({
    name: '',
    description: '',
    location: '',
    start_time: null, // Using null initially for date
    end_time: null
  });

  async function submit() {
    await $form.post('/events');
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
      router.visit('/events'); // Redirect to events page when cancel is clicked
    }
  }
</script>

<div class="max-w-xl p-8 mx-auto mb-24">
  <h1 class="mb-6 text-2xl font-bold">Buat Acara Baru
  </h1>
  <form on:submit|preventDefault={submit}>

    <div class="mb-4">
      <label for="name" class="block mb-2 text-sm font-medium">Nama</label>
      <input
        type="text"
        bind:value={$form.name}
        id="name"
        class="block w-full p-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"
      />
      {#if $form.errors.name}
        <div class="form-error">{$form.errors.name}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="location" class="block mb-2 text-sm font-medium">Lokasi</label>
      <input
        type="text"
        bind:value={$form.location}
        id="location"
        class="block w-full p-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"
      />
      {#if $form.errors.location}
        <div class="form-error">{$form.errors.location}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="description" class="block mb-2 text-sm font-medium">Deskripsi</label>
      <textarea
        bind:value={$form.description}
        id="description"
        class="block w-full p-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"
      ></textarea>
      {#if $form.errors.description}
        <div class="form-error">{$form.errors.description}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="start_time" class="block mb-2 text-sm font-medium">Mulai</label>
      <input
        id="start_time"
        type="datetime-local"
        bind:value={$form.start_time}
        class="block w-full p-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"
      />
      {#if $form.errors.start_time}
        <div class="form-error">{$form.errors.start_time}</div>
      {/if}
    </div>

    <div class="mb-4">
      <label for="end_time" class="block mb-2 text-sm font-medium">Akhir</label>
      <input
        id="end_time"
        type="datetime-local"
        bind:value={$form.end_time}
        class="block w-full p-2 mt-1 border rounded-md shadow-sm focus:ring focus:border sm:text-sm"
      />
      {#if $form.errors.end_time}
        <div class="form-error">{$form.errors.end_time}</div>
      {/if}
    </div>

    <button
      type="submit"
      disabled={$form.processing}
      class="bg-blue-500 text-white py-2 px-4 rounded-md shadow-sm hover:bg-blue-600"
    >
      Buat Acara
    </button>
    <button
      type="button"
      on:click={cancel}
      class="ml-4 bg-gray-500 text-white py-2 px-4 rounded-md shadow-sm hover:bg-gray-600"
    >
      Cancel
    </button>
  </form>
</div>
