fn main() {
    let llama_model = llama_cpp::LlamaModel::load_from_file(
        "/tmp/aaaaa",
        Default::default()
    );

    whisper_rs::WhisperContext::new_with_params(& "/tmp/aaaaa", Default::default());
}
